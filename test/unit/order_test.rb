require File.join(File.dirname(__FILE__), '..', 'test_helper')

class OrderTest < ActiveSupport::TestCase
  should_belong_to :address
  should_have_digest :token
  should_have_one :donation

  should_validate_presence_of :address

  context '.shipped_count' do
    should 'return the number of orders that have all their batches shipped' do
      2.times do
        order = Factory.build(:order)
        order.items << Factory.build(:item, :batch => Factory.build(:batch))
        order.save!
        order.batches.each(&:ship!)
      end

      chaff = Factory.build(:order)
      # Needs at least 2 unshipped batches for an order to test distinct
      3.times do
        chaff.items << Factory.build(:item, :batch => Factory.build(:batch))
      end
      chaff.save!
      chaff.items[0].batch.ship!

      assert_equal 2, Order.shipped_count
    end
  end

  context 'donated named scope' do
    should 'include orders that have a donation' do
      orders = [
        Factory.create(:order),
        Factory.create(:order)
      ].each do |order|
        Factory.create(:donation, :order => order)
      end

      chaff = Factory.create(:order)

      assert_equal orders, Order.donated
    end
  end

  context 'with an unsaved Order' do
    setup { @order = Factory.build(:order, :token => nil) }
    context 'saving' do
      setup { @order.save! }
      should_change('@order.token', :from => nil) { @order.token }
    end
  end

  context 'a validated Order with an invalid Address' do
    setup { @order = Factory.create(:distributor).orders.build(:address => {}); @order.valid? }
    should('have errors on address') { assert @order.errors.on(:address) }
    should('address should have errors on attributes') { assert @order.address.errors.any? }
  end

  context 'initializing with address attributes' do
    setup { @order = Factory.create(:distributor).orders.build(:address => Factory.attributes_for(:address)) }
    should('make an address') { assert_equal Address, @order.address.class }
    should('make a new record') { assert @order.address.new_record? }

    context 'and then saving' do
      setup { @order.save! }
      should_change('@order.address.new_record?', :to => false) { @order.address.new_record? }
    end
  end

  context 'an existing Cart with 2 Items' do
    setup do
      @distributor = Factory.create(:distributor, :currency => 'GBP')
      @cart = Factory.create(:cart, :distributor => @distributor, :additional_donation_amount => 1)
      2.times { @cart.items << Factory.create(:item) }
    end

    context 'build_order with valid attributes' do
      setup { @order = @cart.build_order(:address => Factory.attributes_for(:address)) }
      should('make an Order') { assert_equal Order, @order.class }
      should('make a new record') { assert @order.new_record? }
      should('initialize additional_donation_amount') { assert_equal @cart.additional_donation_amount, @order.additional_donation_amount }
      should('initialize distributor') { assert_equal @cart.distributor, @order.distributor }
      should('associate items') do
        @cart.items.zip(@order.items).each do |old_item, new_item|
          assert_equal old_item.quantity, new_item.quantity
          assert_equal old_item.total,    new_item.total
          assert_equal old_item.variant,  new_item.variant
        end
      end

      context 'and then save the order' do
        setup { @order.save! }
        should_change('@order.items.count', :from => 0, :to => 2) { @order.items.count }
        should_change('@distributor.orders.count', :by => 1) { @distributor.orders.count }
      end
    end
  end

  should 'delegate donation_methods to distributor' do
    @order = Factory.build(:order)
    @order.distributor.stubs(:donation_methods).returns('DONATION_METHODS')
    assert_equal 'DONATION_METHODS', @order.donation_methods
  end

  context 'an existing Order' do
    setup { @order = Factory(:order) }

    should('return false for distributor_changed?') { assert !@order.distributor_changed? }
    should('return nil for distributor_was') { assert_nil @order.distributor_was }
    should('return nil for donation_method') { assert_nil @order.donation_method }
    should('return nil for donation_created_at') { assert_nil @order.donation_created_at }
    should('return nil for donation_received_at') { assert_nil @order.donation_received_at }
    should('return nil for shipped_at') { assert_nil @order.shipped_at }

    context 'with a donation' do
      setup { Factory(:donation, :order => @order) }

      should('delegate donation_method to donation') do
        assert_equal @order.donation.donation_method, @order.donation_method
      end

      should('delegate donation_created_at to donation') do
        assert_equal @order.donation.created_at, @order.donation_created_at
      end

      should('delegate donation_received_at to donation') do
        assert_equal @order.donation.received_at, @order.donation_received_at
      end
    end

    context '#sent?' do
      should 'be false' do
        assert !@order.sent?
      end
    end

    context '#shipped_at' do
      should 'be nil' do
        assert_nil @order.shipped_at
      end
    end

    context 'with shipped batches' do
      setup do
        @recent_batch = Factory(:batch, :shipped_at => 2.days.ago)
        chaff_batch   = Factory(:batch, :shipped_at => 3.days.ago)
        Factory.create(:item, :list => @order, :batch => @recent_batch)
        Factory.create(:item, :list => @order, :batch => chaff_batch)
        @order.reload
      end

      context '#shipped_at' do
        should('be the most recent shipped_at date of the batches') do
          assert_equal @recent_batch.shipped_at.to_i, @order.shipped_at.to_i
        end
      end

      context '#sent?' do
        should 'be true' do
          assert @order.sent?
        end
      end
    end
  end

  should 'answer token for to_param' do
    order = Factory.build(:order, :token => :token)
    assert_equal :token, order.to_param
  end

  should 'return items_for a product' do
    order = Order.new
    match = stub(:product => 'PRODUCT')
    other = stub(:product => 'SOME OTHER PRODUCT')
    order.stubs(:items).returns [match, other]
    assert_equal [match], order.items_for('PRODUCT')
  end

  context 'maintaining inventory counter caches' do
    setup do
      @distributor = Factory.create(:distributor)
      Factory.create(:inventory, :distributor => @distributor)
      Factory.create(:inventory, :distributor => @distributor)

      @order = Factory.build(:order, :distributor => @distributor)
      @distributor.inventories.each do |inventory|
        @order.items << Factory.build(:item,
          :variant => Factory.create(:variant, :product => inventory.product),
          :batch   => Factory.build(:batch, :distributor => @distributor))
      end

      @capture_count_differences = lambda do |attribute, block|
        counts = lambda do |attribute|
          @distributor.inventories.map do |inventory|
            inventory.reload.send(attribute)
          end
        end

        original_counts = counts.call(attribute)
        block.call
        adjusted_counts = counts.call(attribute)
        original_counts.zip(adjusted_counts).map { |o, a| a - o }
      end
    end

    should 'increment promised inventory for each item on order create' do
      expected_differences = @order.items.map { |item| item.product_count }
      actual_differences = @capture_count_differences.call(:promised, lambda {
        @order.save!
      })
      assert_equal expected_differences, actual_differences
    end

    should 'decrement promised inventory for each item when destroying an order' do
      @order.save!

      expected_differences = @order.items.map { |item| -item.product_count }
      actual_differences = @capture_count_differences.call(:promised, lambda {
        @order.destroy
      })
      assert_equal expected_differences, actual_differences
    end

    should 'increment shipped inventory for each item when a batch is shipped' do
      @order.save!

      expected_differences = @order.items.map { |item| item.product_count }
      actual_differences = @capture_count_differences.call(:shipped, lambda {
        @order.batches.each(&:ship!)
      })
      assert_equal expected_differences, actual_differences
    end

    should 'decrement shipped inventory for each item when a batch is unshipped' do
      @order.save!
      @order.batches.each(&:ship!)

      expected_differences = @order.items.map { |item| -item.product_count }
      actual_differences = @capture_count_differences.call(:shipped, lambda {
        @order.batches.each {|x| x.update_attributes!(:shipped_at => nil) }
      })
      assert_equal expected_differences, actual_differences
    end
  end

  context 'creating an Order entirely composed of on-demand products' do
    should "assign items to one batch that doesn't have a distributor" do
      order = Factory.build(:order)
      order.items = (0..1).map { Factory.build(:item) }

      assert_difference('Batch.count', 1) do
        order.save!
      end

      assert_nil Batch.last.distributor

      expected = [Batch.last]
      actual = order.items.collect { |item| item.reload.batch }.uniq
      assert_equal expected, actual
    end
  end

  context 'creating an Order entirely composed of non-on-demand products' do
    should "assign items to one batch that does have a distributor" do
      distributor = Factory.create(:distributor)
      order = Factory.build(:order, :distributor => distributor)

      2.times do
        product = Factory.create(:inventory, :distributor => distributor).product
        variant = Factory.create(:variant, :product => product)
        order.items << Factory.build(:item, :variant => variant)
      end

      assert_difference('Batch.count', 1) do
        order.save!
      end

      assert_equal distributor, Batch.last.distributor

      expected = [Batch.last]
      actual = order.items.collect { |item| item.reload.batch }.uniq
      assert_equal expected, actual
    end
  end

  context '#donation_made?' do
    should 'be true iff a donation exists for the order' do
      order = Factory.build(:order)
      assert !order.donation_made?

      order.donation = Factory.build(:donation, :order => order)
      assert order.donation_made?
    end
  end

  context '#donation_received?' do
    should 'be true iff a donation exists for the order and has been received' do
      order = Factory.build(:order)
      assert !order.donation_received?

      order.donation = Factory.build(:donation,
        :received_at => nil,
        :order       => order)
      assert !order.donation_received?

      order.donation.received_at = 1.day.ago
      assert order.donation_received?
    end
  end

  context 'destroying an order' do
    should 'be allowed if no batches have been shipped' do
      order = Factory.create(:order)
      order.items << Factory.create(:item, :batch => Factory.create(:batch))
      order.items << Factory.create(:item, :batch => Factory.create(:batch))

      assert order.destroy
    end

    should 'be forbidden if any batch for the order has been shipped' do
      order = Factory.create(:order)
      order.items << Factory.create(:item, :batch => Factory.create(:batch))
      order.items << Factory.create(:item, :batch => Factory.create(:batch))

      order.items[0].batch.ship!

      assert !order.destroy
    end
  end
end

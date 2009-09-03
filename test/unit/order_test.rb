require File.join(File.dirname(__FILE__), '..', 'test_helper')

class OrderTest < ActiveSupport::TestCase
  should_belong_to :address
  # FIXME has_digest needs to be updated to work with latest shoulda
  # should_have_digest :token
  should_have_one :donation
  should_have_one :shipment

  should_validate_presence_of :address

  context 'shipped named scope' do
    should 'include orders that have a shipment, order by created at' do
      orders = [
        Factory.create(:order, :created_at => 2.days.ago),
        Factory.create(:order, :created_at => 3.days.ago)
      ].each do |order|
        Factory.create(:shipment, :order => order)
      end

      chaff = Factory.create(:order)

      assert_equal orders.reverse, Order.shipped
    end
  end

  context 'unshipped named scope' do
    should 'include orders that do not have a shipment, order by created at' do
      orders = [
        Factory.create(:order, :created_at => 2.days.ago),
        Factory.create(:order, :created_at => 3.days.ago)
      ]

      chaff = Factory.create(:shipment).order

      assert_equal orders.reverse, Order.unshipped
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
        should_not_change('@order.shipment') { @order.shipment }
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

  context 'an existing USD Order' do
    setup do
      @order = Factory.build(:order, :distributor => Factory(:distributor, :currency => 'USD'))
      product = Factory.create(:inventory, :distributor => @order.distributor).product
      variant = Factory.create(:variant, :product => product)
      @order.items << Factory.build(:item, :variant => variant)
      @order.save!
    end

    context 'updating to a GBP distributor' do
      setup do
        @old = @order.distributor
        @order.distributor = Factory(:distributor, :currency => 'GBP')
      end

      should('return true for distributor_changed?') { assert @order.distributor_changed? }
      should('return @old for distributor_was') { assert_equal @old, @order.distributor_was }

      context 'save without an additional donation' do
        setup { @order.save! }
        should_not_change('@order.additional_donation_amount') { @order.additional_donation_amount }
      end

      should 'transfer batch to new distributor' do
        @order.save!
        assert_equal [@order.distributor], @order.items.reject(&:on_demand?).collect {|x|
          x.batch.distributor
        }
      end
    end

    context 'with an additional donation' do
      setup { @order.update_attributes(:additional_donation_amount => 10) }

      context 'updating to a GBP distributor' do
        setup { @order.reload.update_attributes(:distributor_id => Factory(:distributor, :currency => 'GBP').id) }
        should_change('@order.additional_donation_amount', :to => 5) { @order.additional_donation_amount }
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
        @order.items << Factory.build(:item, :variant => Factory.create(:variant, :product => inventory.product))
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

    should 'increment shipped inventory for each item on shipment create' do
      @order.save!

      shipment = Factory.build(:shipment, :order => @order)

      expected_differences = @order.items.map { |item| item.product_count }
      actual_differences = @capture_count_differences.call(:shipped, lambda {
        shipment.save!
      })
      assert_equal expected_differences, actual_differences
    end

    should 'decrement shipped inventory for each item on shipment destroy' do
      @order.save!

      shipment = Factory.build(:shipment, :order => @order)
      shipment.save!

      expected_differences = @order.items.map { |item| -item.product_count }
      actual_differences = @capture_count_differences.call(:shipped, lambda {
        shipment.destroy
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
end

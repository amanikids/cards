require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should_have_named_scope :shipped,   :include => :shipment, :conditions => 'shipments.id IS NOT NULL', :order => 'lists.created_at'
  should_have_named_scope :unshipped, :include => :shipment, :conditions => 'shipments.id IS NULL',     :order => 'lists.created_at'

  should_belong_to :address
  should_have_digest :token
  should_have_one :donation
  should_have_one :shipment

  should_require_attributes :address

  context 'with an unsaved Order' do
    setup { @order = Factory.build(:order, :token => nil) }
    context 'saving' do
      setup { @order.save! }
      should_change '@order.token', :from => nil
    end
  end

  context 'a validated Order with an invalid Address' do
    setup { @order = Order.new(:address => {}); @order.valid? }
    should('have errors on address') { assert @order.errors.on(:address) }
    should('address should have errors on attributes') { assert @order.address.errors.any? }
  end

  context 'initializing with address attributes' do
    setup { @order = Order.new(:address => Factory.attributes_for(:address)) }
    should('make an address') { assert_equal Address, @order.address.class }
    should('make a new record') { assert @order.address.new_record? }

    context 'and then saving' do
      setup { @order.save! }
      should_change '@order.address.new_record?', :to => false
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
        should_change '@order.items.count', :from => 0, :to => 2
        should_change '@distributor.orders.count', :by => 1
        should_not_change '@order.shipment'
      end
    end
  end

  context 'an existing Cart entirely downloadable' do
    setup do
      @cart = Factory.create(:cart)
      2.times { @cart.items << Factory.create(:downloadable_item) }
    end

    context 'build_order with valid attributes' do
      setup { @order = @cart.build_order(:address => Factory.attributes_for(:address)) }

      context 'and then save the order' do
        setup { @order.save! }
        should_change 'Shipment.count', :by => 1
        should('be shipped') { assert_not_nil @order.shipped_at }
      end
    end
  end

  should 'delegate donation_methods to distributor' do
    @order = Factory.build(:order)
    @order.distributor.stubs(:donation_methods).returns('DONATION_METHODS')
    assert_equal 'DONATION_METHODS', @order.donation_methods
  end

  context 'a new Order' do
    setup { @order = Factory.build(:order) }
    should('not be immediately shippable') { assert !@order.immediately_shippable? }
    should('not have any downloads') { assert_equal [], @order.downloads }

    context 'with some items downloadable, some not' do
      setup { @order.stubs(:items).returns [stub(:download => nil), stub(:download => 'DOWNLOAD_TWO')] }
      should('not be immediately shippable') { assert !@order.immediately_shippable? }
      should('collect downloadable variants') { assert_equal ['DOWNLOAD_TWO'], @order.downloads }
    end

    context 'with all items downloadable' do
      setup { @order.stubs(:items).returns [stub(:download => 'DOWNLOAD_ONE'), stub(:download => 'DOWNLOAD_TWO')] }
      should('be immediately shippable') { assert @order.immediately_shippable? }
      should('collect downloadable variants') { assert_equal ['DOWNLOAD_ONE', 'DOWNLOAD_TWO'], @order.downloads }
    end

    context 'with duplicate downloads' do
      setup { @order.stubs(:items).returns [stub(:download => 'DOWNLOAD_ONE'), stub(:download => 'DOWNLOAD_TWO'), stub(:download => 'DOWNLOAD_ONE')] }
      should('uniq downloadable variants') { assert_equal ['DOWNLOAD_ONE', 'DOWNLOAD_TWO'], @order.downloads }
    end
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
      should('delegate donation_method to donation') { assert_equal @order.donation.donation_method, @order.donation_method }
      should('delegate donation_created_at to donation') { assert_equal @order.donation.created_at, @order.donation_created_at }
      should('delegate donation_received_at to donation') { assert_equal @order.donation.received_at, @order.donation_received_at }
    end

    context 'with a shipment' do
      setup { Factory.create(:shipment, :order => @order) }
      should('delegate shipped_at to shipment') { assert_equal @order.shipment.created_at, @order.shipped_at }
    end
  end

  context 'an existing USD Order' do
    setup { @order = Factory(:order, :distributor => Factory(:distributor, :currency => 'USD')) }

    context 'updating to a GBP distributor' do
      setup do
        @old = @order.distributor
        @order.distributor = Factory(:distributor, :currency => 'GBP')
      end

      should('return true for distributor_changed?') { assert @order.distributor_changed? }
      should('return @old for distributor_was') { assert_equal @old, @order.distributor_was }

      context 'save without an additional donation' do
        setup { @order.save }
        should_not_change '@order.additional_donation_amount'
      end
    end

    context 'with an additional donation' do
      setup { @order.update_attributes(:additional_donation_amount => 10) }

      context 'updating to a GBP distributor' do
        setup { @order.reload.update_attributes(:distributor_id => Factory(:distributor, :currency => 'GBP').id) }
        should_change '@order.additional_donation_amount', :to => 5
      end
    end
  end

  should 'answer token for to_param' do
    order = Factory.build(:order, :token => :token)
    assert_equal :token, order.to_param
  end

  should 'return items_for a sku' do
    order = Order.new
    match = stub(:sku => 'SKU')
    other = stub(:sku => 'SOME OTHER SKU')
    order.stubs(:items).returns [match, other]
    assert_equal [match], order.items_for('SKU')
  end
end

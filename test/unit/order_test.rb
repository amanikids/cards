require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should_have_named_scope :shipped,   :include => :shipment, :conditions => 'shipments.id IS NOT NULL', :order => 'lists.created_at'
  should_have_named_scope :unshipped, :include => :shipment, :conditions => 'shipments.id IS NULL',     :order => 'lists.created_at'

  should_belong_to :address
  should_have_one :payment
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
    setup { @cart = Factory.create(:cart); 2.times { @cart.items << Factory.create(:item) } }

    context 'build_order with valid attributes' do
      setup { @order = @cart.build_order(:address => Factory.attributes_for(:address)) }
      should('make an Order') { assert_equal Order, @order.class }
      should('make a new record') { assert @order.new_record? }
      should('associate items') { assert_same_elements @cart.items, @order.items }
      should_not_change '@cart.reload.items.count'

      context 'and then save the order' do
        setup { @order.save! }
        should_change '@cart.items.count',  :from => 2, :to => 0
        should_change '@order.items.count', :from => 0, :to => 2
        should_not_change '@order.shipment'
      end
    end
  end

  context 'an existing Cart entirely downloadable' do
    setup do
      Factory.create(:system_user)
      @cart = Factory.create(:cart)
      2.times { @cart.items << Factory.create(:downloadable_item) }
    end

    context 'build_order with valid attributes' do
      setup { @order = @cart.build_order(:address => Factory.attributes_for(:address)) }

      context 'and then save the order' do
        setup { @order.save! }
        should_change 'Shipment.count', :by => 1
        should('be shipped') { assert_not_nil @order.shipped_at }
        should('be shipped by the system') { assert_equal SystemUser.first, @order.shipper }
      end
    end
  end

  context 'an order with an address in SOME COUNTRY' do
    setup { @order = Factory.build(:order, :address => Factory.build(:address, :country => 'SOME COUNTRY')) }

    context 'asking for payment methods' do
      setup { @order.payment_methods }

      before_should 'delegate to PaymentMethod' do
        PaymentMethod.expects(:for).with('SOME COUNTRY')
      end
    end
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
  end

  context 'an order with no payment' do
    setup { @order = Factory.build(:order) }
    should('return nil for payment_method') { assert_nil @order.payment_method }
    should('return nil for payment_created_at') { assert_nil @order.payment_created_at }
    should('return nil for payment_received_at') { assert_nil @order.payment_received_at }
    should('return nil for payment_recipient') { assert_nil @order.payment_recipient }
  end

  context 'an order with a payment' do
    setup { @order = Factory.create(:payment).order }
    should('delegate payment_method to payment') { assert_equal @order.payment.payment_method, @order.payment_method }
    should('delegate payment_created_at to payment') { assert_equal @order.payment.created_at, @order.payment_created_at }
    should('delegate payment_received_at to payment') { assert_equal @order.payment.received_at, @order.payment_received_at }
    should('delegate payment_recipient to payment') { assert_equal @order.payment.recipient, @order.payment_recipient }
  end

  context 'an order with no shipment' do
    setup { @order = Factory.build(:order) }
    should('return nil for shipper') { assert_nil @order.shipper }
    should('return nil for shipped_at') { assert_nil @order.shipped_at }
  end

  context 'an order with a shipment' do
    setup { @order = Factory.create(:shipment).order }
    should('delegate shipper to shipment') { assert_equal @order.shipment.shipper, @order.shipper }
    should('delegate shipped_at to shipment') { assert_equal @order.shipment.created_at, @order.shipped_at }
  end

  should 'answer token for to_param' do
    order = Factory.build(:order, :token => :token)
    assert_equal :token, order.to_param
  end
end

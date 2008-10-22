require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  should_have_named_scope :shipped,   :include => :shipment, :conditions => 'shipments.id IS NOT NULL', :order => 'lists.created_at'
  should_have_named_scope :unshipped, :include => :shipment, :conditions => 'shipments.id IS NULL',     :order => 'lists.created_at'

  should_have_one :payment
  should_have_one :shipment

  should 'be confirmed' do
    assert Order.new.confirmed?
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
end

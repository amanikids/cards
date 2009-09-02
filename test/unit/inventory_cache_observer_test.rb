require 'test_helper'

class InventoryCacheObserverTest < ActiveSupport::TestCase
  subject { InventoryCacheObserver.instance }
  should_observe :order, :shipment

  context 'order' do
    setup { @order = Factory(:order) }

    context 'after_create' do
      setup { @result = subject.after_create(@order) }
      before_should('update inventory') { @order.distributor.expects(:order_created).with(@order) }
    end

    context 'before_update' do
      setup { @result = subject.before_update(@order) }
      before_should('not decrement old inventory') { @order.distributor_was.expects(:order_destroyed).with(@order).never }
      before_should('not increment new inventory') { @order.distributor.expects(:order_created).with(@order).never }
      should('return true') { assert @result }
    end

    context 'with a new distributor' do
      setup do
        @order.distributor = Factory(:distributor)
        @order.stubs(:distributor_was).returns(stub(:order_destroyed))
      end

      context 'before_update' do
        setup { @result = subject.before_update(@order) }
        before_should('decrement old inventory') { @order.distributor_was.expects(:order_destroyed).with(@order) }
        before_should('increment new inventory') { @order.distributor.expects(:order_created).with(@order) }
        should('return true') { assert @result }
      end
    end

    context 'before_destroy' do
      setup { @result = subject.before_destroy(@order) }
      before_should('update inventory') { @order.distributor.expects(:order_destroyed).with(@order) }
      should('return true') { assert @result }
    end
  end

  context 'shipment' do
    setup { @shipment = Factory(:shipment) }

    context 'after_create' do
      setup { subject.after_create(@shipment) }
      before_should('update inventory') { @shipment.order.distributor.expects(:shipment_created).with(@shipment.order) }
    end

    context 'before_destroy' do
      setup { @result = subject.before_destroy(@shipment) }
      before_should('update inventory') { @shipment.order.distributor.expects(:shipment_destroyed).with(@shipment.order) }
      should('return true') { assert @result }
    end
  end
end

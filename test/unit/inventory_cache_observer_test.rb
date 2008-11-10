require 'test_helper'

class InventoryCacheObserverTest < ActiveSupport::TestCase
  should_observe :order, :shipment

  context 'order' do
    setup { @order = Factory(:order) }

    context 'after_create' do
      setup { @result = observer.after_create(@order) }
      before_should('update inventory') { @order.distributor.expects(:order_created).with(@order) }
    end

    context 'before_destroy' do
      setup { @result = observer.before_destroy(@order) }
      before_should('update inventory') { @order.distributor.expects(:order_destroyed).with(@order) }
      should('return true') { assert @result }
    end
  end

  context 'shipment' do
    setup { @shipment = Factory(:shipment) }

    context 'after_create' do
      setup { observer.after_create(@shipment) }
      before_should('update inventory') { @shipment.order.distributor.expects(:shipment_created).with(@shipment.order) }
    end

    context 'before_destroy' do
      setup { @result = observer.before_destroy(@shipment) }
      before_should('update inventory') { @shipment.order.distributor.expects(:shipment_destroyed).with(@shipment.order) }
      should('return true') { assert @result }
    end
  end
end

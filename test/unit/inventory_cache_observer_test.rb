require 'test_helper'

class InventoryCacheObserverTest < ActiveSupport::TestCase
  should_observe :order, :shipment

  should 'tell order distributor to reset inventory cache after create' do
    order = Factory.build(:order)
    order.distributor.expects(:order_unshipped).with(order)
    observer.after_create(order)
  end

  should 'tell shipment order distributor to reset inventory cache after create' do
    shipment = Factory.build(:shipment)
    shipment.order.distributor.expects(:order_shipped).with(shipment.order)
    observer.after_create(shipment)
  end
end

class InventoryCacheObserver < ActiveRecord::Observer
  observe :order, :shipment

  def after_create(record)
    send "after_create_#{record.class.name.underscore}", record
  end

  private

  def after_create_order(order)
    order.distributor.order_unshipped(order)
  end

  def after_create_shipment(shipment)
    shipment.order.distributor.order_shipped(shipment.order)
  end
end

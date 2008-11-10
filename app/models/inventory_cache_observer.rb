class InventoryCacheObserver < ActiveRecord::Observer
  observe :order, :shipment

  def after_create(record)
    send "after_create_#{record.class.name.underscore}", record
  end

  def before_destroy(record)
    send "before_destroy_#{record.class.name.underscore}", record
  end

  private

  def after_create_order(order)
    order.distributor.order_created(order)
  end

  def after_create_shipment(shipment)
    shipment.order.distributor.shipment_created(shipment.order)
  end

  def before_destroy_order(order)
    # TODO before_destroy_order
    true
  end

  def before_destroy_shipment(shipment)
    shipment.order.distributor.shipment_destroyed(shipment.order)
  end
end

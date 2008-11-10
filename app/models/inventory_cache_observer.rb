class InventoryCacheObserver < ActiveRecord::Observer
  observe :order, :shipment

  def after_create(record)
    send "after_create_#{record.class.name.underscore}", record
  end

  def before_update(record)
    send "before_update_#{record.class.name.underscore}", record
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

  def before_update_order(order)
    if order.distributor_changed?
      order.distributor_was.order_destroyed(order)
      order.distributor.order_created(order)
    else
      true
    end
  end

  def before_update_shipment(shipment)
    true
  end

  def before_destroy_order(order)
    order.distributor.order_destroyed(order)
  end

  def before_destroy_shipment(shipment)
    shipment.order.distributor.shipment_destroyed(shipment.order)
  end
end

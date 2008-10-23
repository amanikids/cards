class NotificationObserver < ActiveRecord::Observer
  observe :order, :shipment

  def after_create(record)
    send "after_create_#{record.class.name.underscore}", record
  end

  private

  def after_create_order(order)
    Mailer.deliver_order_thank_you(order)
  end

  def after_create_shipment(shipment)
    Mailer.deliver_order_shipped(shipment.order)
  end
end

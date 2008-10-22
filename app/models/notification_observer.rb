class NotificationObserver < ActiveRecord::Observer
  observe :list, :shipment

  def after_create(model)
    method = "after_create_#{model.class.name.underscore}"
    send(method, model) if respond_to?(method)
  end

  def after_update(model)
    method = "after_update_#{model.class.name.underscore}"
    send(method, model) if respond_to?(method)
  end

  protected

  def after_create_shipment(shipment)
    Mailer.deliver_order_shipped(shipment.order)
  end

  def after_update_cart(cart)
    return unless cart.type == 'Order'
    Mailer.deliver_order_thank_you(Order.find(cart.id))
  end
end

class NotificationObserver < ActiveRecord::Observer
  observe :list

  def after_update(model)
    send "after_update_#{model.class.name.underscore}", model
  end

  private

  def after_update_cart(cart)
    return unless cart.type == 'Order'
    Mailer.deliver_order_thank_you(Order.find(cart.id))
  end
end

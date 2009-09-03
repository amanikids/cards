class NotificationObserver < ActiveRecord::Observer
  observe :order, :batch

  def after_create(record)
    send "after_create_#{record.class.name.underscore}", record
  end

  def after_update(record)
    if record.is_a?(Batch)
      if record.shipped_at_changed? && record.shipped_at
        Mailer.deliver_shipment_created(record)
      end
    end
  end

  def before_update(record)
    send "before_update_#{record.class.name.underscore}", record
  end

  def before_destroy(record)
    send "before_destroy_#{record.class.name.underscore}", record
  end

  private

  def after_create_order(order)
    Mailer.deliver_order_created(order)
  end

  def after_create_batch(shipment)
    true
  end

  def before_update_order(order)
    if order.distributor_changed?
      Mailer.deliver_order_updated(order)
    else
      true
    end
  end

  def before_update_batch(shipment)
    true
  end

  def before_destroy_order(order)
    Mailer.deliver_order_destroyed(order)
  end

  def before_destroy_batch(shipment)
    true
  end
end

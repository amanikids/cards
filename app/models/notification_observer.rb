class NotificationObserver < ActiveRecord::Observer
  observe :order, :batch

  def after_create(record)
    Mailer.deliver_order_created(record) if record.is_a?(Order)
  end

  def after_update(record)
    if record.is_a?(Batch)
      if record.shipped_at_changed? && record.shipped_at
        Mailer.deliver_shipment_created(record)
      end
    end
  end

  def before_destroy(record)
    Mailer.deliver_order_destroyed(record) if record.is_a?(Order)
  end
end

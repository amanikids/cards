class InventoryCacheObserver < ActiveRecord::Observer
  observe :order, :batch

  def after_create(record)
    record.distributor.order_created(record) if record.is_a?(Order)
  end

  def after_update(record)
    return unless record.is_a?(Batch)

    if !record.on_demand? && record.shipped_at_changed?
      if record.shipped_at
        record.distributor.batch_shipped(record)
      else
        record.distributor.batch_unshipped(record)
      end
    end
  end

  def after_destroy(record)
    record.distributor.order_destroyed(record) if record.is_a?(Order)
  end
end

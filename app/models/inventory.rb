class Inventory < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :sku

  attr_protected :initial, :promised, :shipped

  def actual
    initial - shipped
  end

  def available
    actual - promised
  end

  def clear_cache
    self.promised = 0
    self.shipped  = 0
  end

  def promised_item(item)
    self.promised += item.sku_count
  end

  def shipped_item(item)
    self.shipped += item.sku_count
  end
end

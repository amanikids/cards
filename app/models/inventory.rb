class Inventory < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :sku

  def actual
    initial - shipped
  end

  def available
    actual - promised
  end

  def item_unshipped(item)
    update_attributes :promised => (self.promised + item.sku_count)
  end

  def item_shipped(item)
    update_attributes :shipped => (self.shipped + item.sku_count), :promised => (self.promised - item.sku_count)
  end
end

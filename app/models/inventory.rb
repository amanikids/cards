class Inventory < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :sku

  def actual
    initial - shipped
  end

  def actual=(actual)
    self.initial = actual + shipped
  end
  
  def available
    initial - promised
  end

  def item_unshipped(item)
    increment! :promised, item.sku_count
  end

  def item_shipped(item)
    increment! :shipped, item.sku_count
  end
end

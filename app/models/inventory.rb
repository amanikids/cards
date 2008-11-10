class Inventory < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :sku
  attr_accessor :actual
  validates_numericality_of :actual, :only_integer => true, :greater_than_or_equal_to => 0
  before_save :calculate_initial

  def actual
    @actual || initial - shipped
  end

  def available
    initial - promised
  end

  def item_promised(item)
    increment! :promised, item.sku_count
  end

  def item_unpromised(item)
    decrement! :promised, item.sku_count
  end

  def item_shipped(item)
    increment! :shipped, item.sku_count
  end

  def item_unshipped(item)
    decrement! :shipped, item.sku_count
  end

  private

  def actual_before_type_cast
    @actual
  end

  def calculate_initial
    if @actual
      self.initial = @actual.to_i + shipped
    end
  end
end

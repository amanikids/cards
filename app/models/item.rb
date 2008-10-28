class Item < ActiveRecord::Base
  belongs_to :list
  belongs_to :variant

  delegate :download, :product_name, :sku, :to => :variant

  validates_presence_of :variant_id
  validates_numericality_of :quantity, :only_integer => true, :greater_than => 0

  def sku_count
    quantity * variant_size
  end

  def variant_description
    variant.description
  end

  def variant_price
    list.exchanged(variant.price)
  end

  def variant_size
    variant.size
  end

  def total
    # Though it would be nice to say "variant_price * safe_quantity," we're
    # subject to rounding error if we don't multiply first.
    list.exchanged(variant.price * safe_quantity)
  end

  private

  def safe_quantity
    errors.on(:quantity) ? 1 : quantity
  end
end

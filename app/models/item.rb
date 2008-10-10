class Item < ActiveRecord::Base
  belongs_to :order
  belongs_to :variant
  validates_presence_of :order_id, :variant_id
  validates_numericality_of :quantity, :only_integer => true, :greater_than => 0

  def product_name
    variant.product_name
  end

  def total
    if errors.on(:quantity)
      variant.price
    else
      variant.price * quantity
    end
  end
end

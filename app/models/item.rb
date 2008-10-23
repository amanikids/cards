class Item < ActiveRecord::Base
  belongs_to :list
  belongs_to :variant

  delegate :download, :to => :variant

  validates_presence_of :variant_id
  validates_numericality_of :quantity, :only_integer => true, :greater_than => 0

  def product_name
    variant.product_name
  end

  # MAYBE Item should know its currency and return total appropriately
  def total
    if errors.on(:quantity)
      variant.price
    else
      variant.price * quantity
    end
  end
end

class Item < ActiveRecord::Base
  belongs_to :batch
  belongs_to :list
  belongs_to :variant

  delegate :on_demand?, :product_name, :product, :to => :variant
  delegate :description, :size, :to => :variant, :prefix => true

  validates_presence_of :variant_id
  validates_presence_of :list
  validates_numericality_of :quantity, :only_integer => true, :greater_than => 0

  def product_count
    quantity * variant_size
  end

  def variant_price
    list.exchanged(variant.price)
  end

  def total
    variant_price * safe_quantity
  end

  private

  def safe_quantity
    errors.on(:quantity) ? 1 : quantity
  end
end

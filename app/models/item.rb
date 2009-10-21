class Item < ActiveRecord::Base
  belongs_to :batch, :dependent => :destroy
  belongs_to :list
  belongs_to :variant

  delegate :on_demand?, :product_name, :product_short_name, :product, :to => :variant
  delegate :description, :size, :to => :variant, :prefix => true

  validates_presence_of :variant_id
  validates_numericality_of :quantity, :only_integer => true, :greater_than => 0

  after_create :compact_list, :if => :list

  def product_count
    quantity * variant_size
  end

  def product_name_and_short_name
    if product_short_name.blank?
      product_name
    else
      "#{product_name} (#{product_short_name})"
    end
  end

  def variant_price
    list.exchanged(variant.price)
  end

  def total
    variant_price * safe_quantity
  end

  private

  def compact_list
    list.compact!
  end

  def safe_quantity
    errors.on(:quantity) ? 1 : quantity
  end
end

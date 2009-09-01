class Variant < ActiveRecord::Base
  belongs_to :product
  composed_of :price, :class_name => 'Money', :mapping => [%w(cents cents), %w(currency currency)]
  validates_presence_of :cents, :currency, :product_id

  def available?(distributor)
    quantity_available?(distributor, 1)
  end

  def description
    size == 1 ? '' : "#{size}-pack"
  end

  def product_name
    product.name
  end

  def running_low?(distributor)
    !quantity_available?(distributor, 25)
  end

  def to_param
    unix_name
  end

  private

  def quantity_available?(distributor, number_of_packs)
    product.quantity(distributor) >= (number_of_packs * size)
  end
end

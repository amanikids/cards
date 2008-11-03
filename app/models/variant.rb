class Variant < ActiveRecord::Base
  belongs_to :sku
  belongs_to :download
  composed_of :price, :class_name => 'Money', :mapping => [%w(cents cents), %w(currency currency)]
  validates_presence_of :cents, :currency, :sku_id

  def available?(distributor)
    quantity_available?(distributor, 1)
  end

  def description
    size == 1 ? sku_name : "#{size}-pack #{sku_name}"
  end

  def product_name
    sku.product_name
  end

  def running_low?(distributor)
    !quantity_available?(distributor, 25)
  end

  def sku_name
    sku.name
  end

  def to_param
    unix_name
  end

  private

  def quantity_available?(distributor, number_of_packs)
    download || sku.quantity(distributor) >= (number_of_packs * size)
  end
end

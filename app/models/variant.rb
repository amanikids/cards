class Variant < ActiveRecord::Base
  belongs_to :product
  belongs_to :download
  composed_of :price, :class_name => 'Money', :mapping => [%w(cents cents), %w(currency currency)]
  validates_presence_of :name, :cents, :currency, :product_id

  def product_name
    product.name
  end

  def to_param
    unix_name
  end
end

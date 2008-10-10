class Variant < ActiveRecord::Base
  belongs_to :product
  composed_of :price, :class_name => 'Money', :mapping => [[:price_amount, :amount], [:price_currency, :currency]]
  validates_presence_of :name, :price_amount, :price_currency, :product_id

  def product_name
    product.name
  end
end

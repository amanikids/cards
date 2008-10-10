class Variant < ActiveRecord::Base
  belongs_to :product
  composed_of :price, :class_name => 'Money', :mapping => [[:price_amount, :amount], [:price_currency, :currency]]

  def product_name
    product.name
  end
end

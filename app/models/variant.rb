class Variant < ActiveRecord::Base
  belongs_to :product

  def product_name
    product.name
  end
end

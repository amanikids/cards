class Sku < ActiveRecord::Base
  belongs_to :product
  has_many :variants, :order => :position

  def product_name
    product.name
  end
end

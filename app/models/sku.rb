class Sku < ActiveRecord::Base
  belongs_to :product
  has_many :inventories
  has_many :variants, :order => :position

  def product_name
    product.name
  end

  def inventory(distributor)
    inventories.detect { |inventory| inventory.distributor == distributor }
  end

  def quantity(distributor)
    inventory(distributor).available
  end
end

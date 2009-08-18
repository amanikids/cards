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
    inventory = inventory(distributor)
    inventory ? inventory.available : 0
  end
end

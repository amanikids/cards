class Sku < ActiveRecord::Base
  belongs_to :product
  has_many :inventories
  has_many :variants, :order => :position

  def product_name
    product.name
  end

  def quantity(distributor)
    inventory(distributor).quantity
  end

  private

  def inventory(distributor)
    inventories.first :conditions => { :distributor_id => distributor.id }
  end
end

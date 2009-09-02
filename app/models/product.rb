class Product < ActiveRecord::Base
  default_scope :order => :position

  named_scope :on_demand,
    :joins    => 'LEFT JOIN inventories ON products.id = inventories.product_id',
    :conditions => 'inventories.id IS NULL'

  validates_presence_of :name

  has_many :inventories
  has_many :variants

  def available?(distributor)
    available_variants(distributor).any?
  end

  def available_variants(distributor)
    variants.select { |variant| variant.available?(distributor) }
  end

  def inventory(distributor)
    inventories.detect { |inventory| inventory.distributor == distributor }
  end

  def on_demand?
    inventories.empty?
  end

  def quantity(distributor)
    inventory = inventory(distributor)
    inventory ? inventory.available : 0
  end
end

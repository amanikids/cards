class Product < ActiveRecord::Base
  validates_presence_of :name

  has_many :inventories
  has_many :variants

  named_scope :ordered, :order => :position

  def available?(distributor)
    available_variants(distributor).any?
  end

  def available_variants(distributor)
    variants.select { |variant| variant.available?(distributor) }
  end

  def inventory(distributor)
    inventories.detect { |inventory| inventory.distributor == distributor }
  end

  def quantity(distributor)
    inventory = inventory(distributor)
    inventory ? inventory.available : 0
  end
end

class Distributor < User
  named_scope :ordered, :order => :position

  has_many :carts
  has_many :distributor_donation_methods
  has_many :donation_methods, :through => :distributor_donation_methods, :order => :position
  has_many :inventories
  has_many :orders

  validates_presence_of :country_code, :currency

  def self.default
    ordered.first
  end

  def self.find_by_param(param)
    find_by_country_code(param) || raise(ActiveRecord::RecordNotFound)
  end

  def order_shipped(order)
    inventories.each do |inventory|
      order.items_for(inventory.sku).each do |item|
        inventory.item_shipped(item)
      end
    end
  end

  def order_unshipped(order)
    inventories.each do |inventory|
      order.items_for(inventory.sku).each do |item|
        inventory.item_unshipped(item)
      end
    end
  end

  def to_param
    country_code
  end

  def update_inventories(attributes)
    attributes = attributes.stringify_keys
    inventories.map { |inventory| inventory.update_attributes attributes[inventory.id.to_s] }.all?
  end
end
class Distributor < User
  has_many :carts
  has_many :distributor_donation_methods
  has_many :donation_methods, :through => :distributor_donation_methods, :order => :position
  has_many :inventories
  has_many :orders

  validates_presence_of :country_code, :currency

  def self.default
    first :order => :position
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
end
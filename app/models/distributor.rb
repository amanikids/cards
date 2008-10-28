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

  def orders_shipped
    orders.shipped
  end

  def orders_unshipped
    orders.unshipped
  end

  def reset_inventory_cache
    clear_inventory_cache
    count_orders_unshipped
    count_orders_shipped
    save_inventory
  end

  def to_param
    country_code
  end

  private

  def clear_inventory_cache
    inventories.each { |inventory| inventory.clear_cache }
  end

  def count_orders_unshipped
    orders_unshipped.each do |order|
      inventories.each do |inventory|
        order.items_for(inventory.sku).each do |item|
          inventory.promised_item(item)
        end
      end
    end
  end

  def count_orders_shipped
    orders_shipped.each do |order|
      inventories.each do |inventory|
        order.items_for(inventory.sku).each do |item|
          inventory.shipped_item(item)
        end
      end
    end
  end

  def save_inventory
    inventories.each { |inventory| inventory.save }
  end
end
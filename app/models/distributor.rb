class Distributor < User
  named_scope :ordered, :order => :position

  has_many :carts
  has_many :distributor_donation_methods
  has_many :donation_methods, :through => :distributor_donation_methods, :order => :position
  has_many :inventories
  has_many :orders

  validates_presence_of :country_code, :currency
  validates_uniqueness_of :country_code

  def self.default
    find_by_country_code('uk')
  end

  def self.find_by_param(param)
    find_by_country_code(param) || raise(ActiveRecord::RecordNotFound)
  end

  def order_created(order)
    update_inventories_with_items_from(order, :item_promised)
  end

  def shipment_created(order)
    update_inventories_with_items_from(order, :item_shipped)
  end

  def shipment_destroyed(order)
    update_inventories_with_items_from(order, :item_unshipped)
  end

  def to_param
    country_code
  end

  def unshipped_order_count
    orders.unshipped.count
  end

  def update_inventories(attributes)
    attributes = attributes.stringify_keys
    inventories.map { |inventory| inventory.update_attributes attributes[inventory.id.to_s] }.all?
  end

  private

  def update_inventories_with_items_from(order, event)
    inventories.each do |inventory|
      order.items_for(inventory.sku).each do |item|
        inventory.send(event, item)
      end
    end
  end
end
class Distributor < User
  default_scope :order => :position

  has_many :carts
  has_many :donation_methods, :order => :position
  has_many :inventories
  has_many :products, :through => :inventories
  has_many :orders
  has_many :products, :through => :inventories
  has_many :batches

  validates_presence_of :country_code, :currency
  validates_uniqueness_of :country_code

  def self.default
    find_by_country_code('uk')
  end

  def self.find_by_param(param)
    find_by_country_code(param) || raise(ActiveRecord::RecordNotFound)
  end

  def available_products
    products.select { |product| product.available?(self) }
  end

  def order_created(order)
    update_inventories_with_items_from(order, :item_promised)
  end

  def order_destroyed(order)
    update_inventories_with_items_from(order, :item_unpromised)
  end

  def others
    Distributor.all - [self]
  end

  def batch_shipped(batch)
    update_inventories_with_items_from(batch, :item_shipped)
  end

  def batch_unshipped(batch)
    update_inventories_with_items_from(batch, :item_unshipped)
  end

  def sold_out?
    available_products.empty?
  end

  def to_param
    country_code
  end

  def unshipped_batch_count
    batches.unshipped.size
  end

  # TODO this should use nested_attributes
  def update_inventories(attributes)
    attributes = attributes.stringify_keys
    inventories.map { |inventory| inventory.update_attributes attributes[inventory.id.to_s] }.all?
  end

  private

  def update_inventories_with_items_from(container, event)
    inventories.each do |inventory|
      container.items_for(inventory.product).each do |item|
        inventory.send(event, item)
      end
    end
  end
end

class Cart < List
  after_update :create_shipment, :if => :order_is_immediately_shippable?

  def blank?
    items.empty?
  end

  def confirmed?
    false
  end

  def confirm!
    self.type = 'Order'
    self.save
  end

  def update_items(attributes)
    attributes = attributes.stringify_keys
    items.inject(true) do |result, item|
      result &&= item.update_attributes(attributes[item.id.to_s])
    end
  end

  private

  def create_shipment
    order = Order.find(id)
    order.create_shipment(:shipper => SystemUser.first)
  end

  def order_is_immediately_shippable?
    type == 'Order' && immediately_shippable?
  end
end

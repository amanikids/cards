class Cart < List
  # MAYBE pull blank? up from Cart to List, and validate that an Order can't be blank
  def blank?
    items.empty?
  end

  def build_order(attributes={})
    returning(Order.new(attributes)) do |order|
      order.currency = currency
      order.item_ids = item_ids
    end
  end

  def update_items(attributes)
    attributes = attributes.stringify_keys
    items.inject(true) do |result, item|
      result &&= item.update_attributes(attributes[item.id.to_s])
    end
  end
end

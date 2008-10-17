class Cart < Order
  def update_items(attributes)
    attributes = attributes.stringify_keys
    items.inject(true) do |result, item|
      result &&= item.update_attributes(attributes[item.id.to_s])
    end
  end
end

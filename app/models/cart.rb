class Cart < List
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
end

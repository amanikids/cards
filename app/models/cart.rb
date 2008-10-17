class Cart < List
  def blank?
    items.empty?
  end

  def confirm!
    self.token = Digest::SHA1.hexdigest(random_string)
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

  def random_string
    Time.now.to_s.split(//).sort_by { rand }.join
  end
end

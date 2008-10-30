class Cart < List
  validates_associated :items

  # MAYBE pull blank? up from Cart to List, and validate that an Order can't be blank
  def blank?
    items.empty?
  end

  def build_order(attributes={})
    returning(Order.new(attributes)) do |order|
      order.additional_donation_amount = additional_donation_amount
      order.distributor = distributor
      items.each { |item| order.items.build(:list => order, :quantity => item.quantity, :variant => item.variant) }
    end
  end

  def items_hash=(attributes)
    attributes = attributes.stringify_keys
    items.each { |item| item.update_attributes attributes[item.id.to_s] }
  end
end

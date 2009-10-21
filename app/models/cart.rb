class Cart < List
  accepts_nested_attributes_for :items, :allow_destroy => true
  validates_associated :items

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
end

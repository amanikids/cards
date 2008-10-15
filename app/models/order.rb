class Order < ActiveRecord::Base
  has_many :items

  def quantity
    quantity = 0
    items.each { |item| quantity += item.quantity }
    quantity
  end

  def total
    total = Money.new(0)
    items.each { |item| total += item.total }
    total
  end

  def update_items(attributes)
    attributes = attributes.stringify_keys
    items.inject(true) do |result, item|
      result &&= item.update_attributes(attributes[item.id.to_s])
    end
  end
end

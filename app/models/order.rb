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

  def update_quantities(attributes)
    true
  end
end

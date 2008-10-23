class List < ActiveRecord::Base
  has_many :items

  def quantity
    quantity = 0
    items.each { |item| quantity += item.quantity }
    quantity
  end

  # MAYBE List should know its currency and return total appropriately
  def total
    total = Money.new(0)
    items.each { |item| total += item.total }
    total
  end
end

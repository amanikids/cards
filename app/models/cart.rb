class Cart < ActiveRecord::Base
  has_many :items

  def total
    items.inject(0) { |total, item| total += item.price }
  end
end

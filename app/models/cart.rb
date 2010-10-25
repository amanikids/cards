class Cart < ActiveRecord::Base
  has_many :items, :inverse_of => :cart

  def empty?
    items.blank?
  end

  def total
    items.inject(0) { |total, item| total += item.price }
  end
end

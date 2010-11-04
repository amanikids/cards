class Cart < ActiveRecord::Base
  belongs_to :store,
    :inverse_of => :carts

  has_many :items,
    :inverse_of => :cart

  has_one :order,
    :inverse_of => :cart

  def empty?
    items.blank?
  end

  def mutable?
    order.blank?
  end

  def total
    items.inject(0) { |total, item| total += item.price }
  end
end

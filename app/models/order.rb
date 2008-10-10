class Order < ActiveRecord::Base
  has_many :items

  def total
    total = Money.new(0)
    items.each { |item| total += item.total }
    total
  end
end

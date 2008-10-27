class List < ActiveRecord::Base
  belongs_to :distributor
  has_many :items

  delegate :currency, :to => :distributor

  def exchanged(money)
    money.currency == currency ? money : money.exchange_to(currency)
  end

  def quantity
    items.inject(0) { |total, item| total + item.quantity }
  end

  def total
    total = items.inject(Money.new(0)) { |total, item| total + item.total }
    exchanged(total)
  end
end

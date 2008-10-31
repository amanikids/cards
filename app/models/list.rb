class List < ActiveRecord::Base
  belongs_to :distributor
  delegate :currency, :to => :distributor
  has_many :items, :dependent => :destroy
  before_validation :convert_blank_additional_donation_amount
  validates_numericality_of :additional_donation_amount, :only_integer => true, :greater_than_or_equal_to => 0

  def additional_donation
    Money.new(100 * additional_donation_amount, currency)
  end

  def exchanged(money)
    money.currency == currency ? money : money.exchange_to(currency)
  end

  def quantity
    items.inject(0) { |total, item| total + item.quantity }
  end

  def total
    total = items.inject(Money.new(0)) { |total, item| total + item.total }
    exchanged(total) + additional_donation
  end

  private

  def convert_blank_additional_donation_amount
    self.additional_donation_amount = 0 if self.additional_donation_amount.blank?
  end
end

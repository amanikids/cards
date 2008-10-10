class Money
  attr_accessor :amount, :currency

  def initialize(amount, currency='USD')
    @amount, @currency = amount, currency
  end

  # TODO include exchange rates, drop to nearest integer
  def converted_to(currency)
    Money.new(amount, currency)
  end

  def +(other)
    Money.new(amount + other.amount, currency)
  end

  def *(number)
    Money.new(amount * number, currency)
  end

  def ==(other)
    self.amount == other.amount && self.currency == other.currency
  end

  def to_s
    "#{amount} #{currency}"
  end
end
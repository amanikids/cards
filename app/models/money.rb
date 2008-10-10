class Money
  attr_accessor :amount, :currency

  def initialize(amount, currency)
    @amount, @currency = amount, currency
  end

  # TODO include exchange rates, drop to nearest integer
  def converted_to(currency)
    Money.new(amount, currency)
  end

  def to_s
    "#{amount} #{currency}"
  end
end
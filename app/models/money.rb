class Money
  attr_accessor :amount, :currency

  def initialize(amount, currency)
    @amount, @currency = amount, currency
  end
end
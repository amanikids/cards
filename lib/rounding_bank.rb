class RoundingBank
  RATES = { 'CAD_to_GBP' => 0.5, 'CAD_to_USD' => 1.0, 'GBP_to_USD' => 2.0 }

  def reduce(money, currency)
    if money.currency == currency
      money
    else
      exchange(money, currency)
    end
  end

  private

  def exchange(money, currency)
    exchanged_cents = money.cents * exchange_rate(money.currency, currency)
    Money.new(round(exchanged_cents.floor), currency)
  end

  def exchange_rate(from, to)
    lookup_exchange_rate(from, to) || 1 / lookup_exchange_rate(to, from) || raise(Money::MoneyError.new("Can't exchage from #{from} to #{to}"))
  end

  def lookup_exchange_rate(from, to)
    RATES["#{from}_to_#{to}"]
  end

  def round(cents)
    cents - (cents % 100)
  end
end

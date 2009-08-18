Money.add_rate('CAD', 'CAD', 1.0)
Money.add_rate('GBP', 'GBP', 1.0)
Money.add_rate('USD', 'USD', 1.0)

Money.add_rate('CAD', 'GBP', 0.5)
Money.add_rate('GBP', 'CAD', 2.0)

Money.add_rate('CAD', 'USD', 1.0)
Money.add_rate('USD', 'CAD', 1.0)

Money.add_rate('GBP', 'USD', 2.0)
Money.add_rate('USD', 'GBP', 0.5)

bank = Money.default_bank

# round farther down, to the whole dollar / pound
def bank.exchange(cents, from_currency, to_currency)
  cents = super
  cents - (cents % 100)
end

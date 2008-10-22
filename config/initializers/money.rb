Money.bank = returning(VariableExchangeBank.new) do |bank|
  bank.add_rate('USD', 'USD', 1.0)
  bank.add_rate('GBP', 'GBP', 1.0)
  bank.add_rate('USD', 'GBP', 0.5)
  bank.add_rate('GBP', 'USD', 2.0)
end
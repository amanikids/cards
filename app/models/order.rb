class Order < List
  has_one :payment

  def donor_editable?
    false
  end

  def payment_methods
    PaymentMethod.for(address.country)
  end
end
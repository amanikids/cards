class Order < List
  has_one :payment

  named_scope :with_payment, :include => :payment, :conditions => 'payments.id IS NOT NULL', :order => 'lists.created_at'
  named_scope :pending,  :conditions => 'payments.received_at IS NULL'
  named_scope :received, :conditions => 'payments.received_at IS NOT NULL'

  def donor_editable?
    false
  end

  def payment_methods
    PaymentMethod.for(address.country)
  end
end
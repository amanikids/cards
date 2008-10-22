class Order < List
  named_scope :shipped,   :include => :shipment, :conditions => 'shipments.id IS NOT NULL', :order => 'lists.created_at'
  named_scope :unshipped, :include => :shipment, :conditions => 'shipments.id IS NULL',     :order => 'lists.created_at'

  has_one :payment
  has_one :payment_method, :through => :payment
  has_one :shipment

  def confirmed?
    true
  end

  def payment_created_at
    payment ? payment.created_at : nil
  end

  def payment_methods
    PaymentMethod.for(address.country)
  end

  def payment_received_at
    payment ? payment.received_at : nil
  end

  def payment_recipient
    payment ? payment.recipient : nil
  end

  def shipper
    shipment ? shipment.shipper : nil
  end

  def shipped_at
    shipment ? shipment.created_at : nil
  end
end
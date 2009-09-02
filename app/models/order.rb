class Order < List
  named_scope :donated,   
    :include    => :donation,
    :conditions => 'donations.id IS NOT NULL'

  named_scope :shipped,   
    :include    => :shipment,
    :conditions => 'shipments.id IS NOT NULL',
    :order      => 'lists.created_at'

  named_scope :unshipped, 
    :include    => :shipment,
    :conditions => 'shipments.id IS NULL',
    :order      => 'lists.created_at'

  belongs_to :address
  has_digest :token
  has_one :donation
  has_one :donation_method, :through => :donation
  has_one :shipment
  validates_presence_of :address
  validates_associated :address

  delegate :name, :email, :country, :to => :address
  delegate :donation_methods, :to => :distributor

  before_update :exchange_additional_donation_amount, :if => :distributor_changed?

  # TODO use the new nested_attributes magic
  def address_with_nested_attributes=(record_or_attributes)
    record = case record_or_attributes
             when Address
               record_or_attributes
             when Hash
               Address.new(record_or_attributes)
             end
    self.address_without_nested_attributes = record
  end

  alias_method_chain :address=, :nested_attributes

  def distributor_changed?
    distributor_id_changed?
  end

  def distributor_was
    Distributor.find(distributor_id_was) if distributor_changed?
  end

  def donation_created_at
    donation ? donation.created_at : nil
  end

  def donation_received_at
    donation ? donation.received_at : nil
  end

  def items_for(product)
    items.select { |item| item.product == product }
  end

  def shipped_at
    shipment ? shipment.created_at : nil
  end

  def to_param
    token
  end

  private

  def exchange_additional_donation_amount
    additional_donation_was = Money.new(100 * additional_donation_amount, distributor_was.currency)
    self.additional_donation_amount = additional_donation_was.exchange_to(distributor.currency).cents / 100
  end
end

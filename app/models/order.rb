class Order < List
  named_scope :shipped,   :include => :shipment, :conditions => 'shipments.id IS NOT NULL', :order => 'lists.created_at'
  named_scope :unshipped, :include => :shipment, :conditions => 'shipments.id IS NULL',     :order => 'lists.created_at'

  belongs_to :address
  has_one :donation
  has_one :donation_method, :through => :donation
  has_one :shipment

  validates_presence_of :address
  validates_associated :address

  delegate :name, :email, :country, :to => :address

  before_create :write_token
  after_create  :ship, :if => :immediately_shippable?

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

  def donation_created_at
    donation ? donation.created_at : nil
  end

  def donation_methods
    DonationMethod.for(country)
  end

  def donation_received_at
    donation ? donation.received_at : nil
  end

  def donation_recipient
    donation ? donation.recipient : nil
  end

  def downloads
    items.collect(&:download).compact
  end

  def immediately_shippable?
    items.all?(&:download) unless items.blank?
  end

  def shipper
    shipment ? shipment.shipper : nil
  end

  def shipped_at
    shipment ? shipment.created_at : nil
  end

  def to_param
    token
  end

  private

  def ship
    create_shipment(:shipper => SystemUser.first)
  end

  def write_token
    self.token = Digest::SHA1.hexdigest(random_string)
  end

  def random_string
    Time.now.to_s.split(//).sort_by { rand }.join
  end
end
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

  after_create  :create_batches
  with_options(:if => :distributor_changed?) do |o|
    o.before_update :exchange_additional_donation_amount
    o.after_update :transfer_distributor_batch
  end

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

  # def donation_created_at
  # def donation_received_at
  delegate :created_at, :received_at,
    :to        => :donation,
    :prefix    => true,
    :allow_nil => true

  def donation_made?
    donation
  end

  def donation_received?
    donation_received_at
  end

  def items_for(product)
    items.select { |item| item.product == product }
  end

  def shipped_at
    items.collect {|x| x.batch.shipped_at }.compact.max
  end

  def to_param
    token
  end

  def sent?
    batches = items.collect(&:batch)
    batches.any? && batches.all?(&:shipped?)
  end

  private

  def create_batches
    items.group_by(&:on_demand?).each do |on_demand, items|
      distributor_for_batch = on_demand ? nil : distributor

      Batch.create!(:distributor => distributor_for_batch).tap do |batch|
        items.each do |item|
          batch.items << item
        end
      end
    end
  end

  def exchange_additional_donation_amount
    additional_donation_was = Money.new(100 * additional_donation_amount, distributor_was.currency)
    self.additional_donation_amount = additional_donation_was.exchange_to(distributor.currency).cents / 100
  end

  def transfer_distributor_batch
    items_to_rebatch = items.reject(&:on_demand?)
    unless items_to_rebatch.empty?
      batch = items_to_rebatch.first.batch
      batch.update_attributes!(:distributor_id => distributor_id)
    end
  end
end

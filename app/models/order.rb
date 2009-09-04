class Order < List
  named_scope :donated,
    :include    => :donation,
    :conditions => 'donations.id IS NOT NULL'

  def self.shipped_count
    count - count(
      :select     => 'DISTINCT lists.id',
      :conditions => 'batches.shipped_at IS NULL',
      :joins      => <<-EOS
        INNER JOIN items ON items.list_id = lists.id
        INNER JOIN batches ON items.batch_id = batches.id
      EOS
    )
  end

  belongs_to :address
  has_digest :token
  has_one :donation
  has_one :donation_method, :through => :donation
  validates_presence_of :address
  validates_associated :address

  delegate :name, :email, :country, :to => :address
  delegate :donation_methods, :to => :distributor

  after_create  :create_batches

  before_destroy :cancellable?

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

  def shipped?
    batches.any? && batches.all?(&:shipped?)
  end

  def cancellable?
    batches.none?(&:shipped?)
  end

  def batches
    items.collect(&:batch).uniq
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
end

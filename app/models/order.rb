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
    # The compact is here because of a tricky case:
    #
    # before_destroy, we require that the order be cancellable, which means
    # that none of the batches are allowed to have been shipped. Except
    # Order#before_destroy is called *after* the order's items have been
    # :dependent => :destroy'ed, since the has_many association is defined (in
    # the List superclass) before our before_destroy :cancellable? callback.
    #
    # So, by the time cancellable? is called, we've already 1-by-1 destroyed
    # each of our items and their associated batches.
    #
    # That 1-by-1 part is important! Only the first item of each batch will
    # have the opportunity to have its batch loaded; all the others will just
    # see a nil batch.
    #
    # So many of our in-memory remaining items will have nil Batches, which
    # will cause trouble in cancellable?, so we eagerly compact them away
    # here.
    items.collect(&:batch).uniq.compact
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

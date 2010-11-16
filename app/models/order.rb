class Order < ActiveRecord::Base
  default_scope order(:created_at)

  scope :shipped,
    # TODO is there a more arel-native way of saying DISTINCT?
    # (One use case: Order.shipped.count is broken, since it uses a
    # different SELECT clause that ignores this one.)
    select('DISTINCT orders.*').
    joins(:cart => :items).
    where(Item.arel_table[:shipped_at].eq(nil).not)

  scope :unshipped,
    # TODO is there a more arel-native way of saying DISTINCT?
    # (One use case: Order.unshipped.count is broken, since it uses a
    # different SELECT clause that ignores this one.)
    select('DISTINCT orders.*').
    joins(:cart => :items).
    where(Item.arel_table[:shipped_at].eq(nil))

  belongs_to :address

  belongs_to :cart,
    :inverse_of => :order

  has_many :items,
    :through => :cart

  belongs_to :payment,
    :polymorphic => true

  has_one :store,
    :through => :cart

  before_create :randomize_token

  accepts_nested_attributes_for :items
  attr_accessible :items_attributes

  def to_param
    token
  end

  private

  def randomize_token
    self.token = ActiveSupport::SecureRandom.base64url(15)
  end
end

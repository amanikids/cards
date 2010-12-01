class Item < ActiveRecord::Base
  belongs_to :cart, :inverse_of => :items
  belongs_to :packaging

  attr_accessible :packaging_id
  attr_accessible :quantity
  attr_accessible :shipped_at

  attr_readonly :cart_id
  attr_readonly :packaging_id
  attr_readonly :unit_price

  validates :quantity,
    :numericality => {
      :greater_than => 0,
      :only_integer => true }

  before_create :populate_unit_price

  delegate :name,
    :to => :packaging
  delegate :product_name,
    :to => :packaging

  # TODO could maybe push some of this up to packaging, but I don't feel too
  # concerned at the moment. On balance, it seems better to have a demeter
  # train wreck than to chase through delegation after delegation. I wonder if
  # there's something I could learn here...
  def transfer_inventory(reason)
    packaging.product.transfers.create!(
      :detail => self,
      :happened_at => Time.zone.now,
      :quantity => (-1 * quantity * packaging.size),
      :reason => reason
    )
  end

  def price
    quantity * unit_price
  end

  private

  def populate_unit_price
    self.unit_price = packaging.price
  end
end

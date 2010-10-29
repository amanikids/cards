class Item < ActiveRecord::Base
  belongs_to :cart, :inverse_of => :items
  belongs_to :packaging

  attr_accessible :packaging_id
  attr_accessible :quantity

  attr_readonly :cart_id
  attr_readonly :packaging_id
  attr_readonly :unit_price

  validates :quantity,
    :numericality => {
      :greater_than_or_equal_to => 0,
      :only_integer => true }

  before_create :populate_unit_price

  delegate :name,
    :to => :packaging
  delegate :product_name,
    :to => :packaging

  def price
    quantity * unit_price
  end

  private

  def populate_unit_price
    self.unit_price = packaging.price
  end
end

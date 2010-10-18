class Item < ActiveRecord::Base
  belongs_to :cart
  belongs_to :product

  attr_readonly :cart_id, :product_id, :unit_price
  attr_accessible :product_id, :quantity

  validates :quantity,
    :numericality => {
      :greater_than_or_equal_to => 0,
      :only_integer => true }

  before_create :populate_unit_price

  private

  def populate_unit_price
    self.unit_price = product.price
  end
end

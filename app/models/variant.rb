class Variant < ActiveRecord::Base
  RUNNING_LOW_THRESHOLD = 25

  default_scope :order => :position

  belongs_to :product
  composed_of :price, :class_name => 'Money', :mapping => [%w(cents cents), %w(currency currency)]
  delegate :name, :short_name, :to => :product, :prefix => true
  delegate :on_demand?, :to => :product
  validates_presence_of :cents, :currency, :product_id

  def available?(distributor)
    on_demand? || quantity_available?(distributor, 1)
  end

  def description
    name.blank? ? "#{size}-pack" : name
  end

  def running_low?(distributor)
    !on_demand? && !quantity_available?(distributor, RUNNING_LOW_THRESHOLD)
  end

  private

  def quantity_available?(distributor, number_of_packs)
    product.quantity(distributor) >= (number_of_packs * size)
  end
end

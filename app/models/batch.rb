class Batch < ActiveRecord::Base
  belongs_to :distributor
  has_many :items

  named_scope :shipped,   :conditions => 'shipped_at IS NOT NULL'
  named_scope :unshipped, :conditions => 'shipped_at IS NULL'
  named_scope :on_demand, :conditions => 'distributor_id IS NULL'

  def order
    items.first.list
  end

  def shipped?
    !shipped_at.nil?
  end

  def ship!
    update_attribute(:shipped_at, Time.zone.now) unless shipped?
  end

  def unship!
    update_attribute(:shipped_at, nil)
  end

  def partial?
    order.items.collect(&:batch).reject {|x| x == self }.any? {|x| !x.shipped? }
  end

  def on_demand?
    distributor.nil?
  end

  def items_for(product)
    items.select { |item| item.product == product }
  end
end

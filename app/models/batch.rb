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
    update_attributes!(:shipped_at => Time.zone.now) unless shipped?
  end

  def partial?
    order.items.collect(&:batch).reject {|x| x == self }.any? {|x| !x.shipped? }
  end
end

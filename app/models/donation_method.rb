class DonationMethod < ActiveRecord::Base
  named_scope :paypal, :conditions => { :name => 'paypal' }

  belongs_to :distributor

  def to_s
    title
  end
end

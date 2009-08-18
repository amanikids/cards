class DonationMethod < ActiveRecord::Base
  named_scope :paypal, :conditions => { :name => 'paypal' }

  def to_s
    title
  end
end

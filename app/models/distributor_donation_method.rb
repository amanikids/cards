class DistributorDonationMethod < ActiveRecord::Base
  belongs_to :distributor
  belongs_to :donation_method
end

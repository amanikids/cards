class Donation < ActiveRecord::Base
  belongs_to :order
  belongs_to :donation_method
end

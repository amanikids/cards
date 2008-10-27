class Donation < ActiveRecord::Base
  belongs_to :order
  belongs_to :donation_method
  belongs_to :recipient, :class_name => 'User'
end

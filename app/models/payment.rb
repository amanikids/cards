class Payment < ActiveRecord::Base
  belongs_to :order
  belongs_to :payment_method
  belongs_to :recipient, :class_name => 'User'
end

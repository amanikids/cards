class Payment < ActiveRecord::Base
  belongs_to :order
  belongs_to :payment_method
end

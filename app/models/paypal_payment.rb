class PaypalPayment < ActiveRecord::Base
  attr_readonly :payer_id
  attr_readonly :token
end

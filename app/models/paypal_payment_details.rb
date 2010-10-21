class PaypalPaymentDetails < ActiveRecord::Base
  attr_accessible :payer_id
  attr_accessible :token

  attr_readonly :payer_id
  attr_readonly :token
end

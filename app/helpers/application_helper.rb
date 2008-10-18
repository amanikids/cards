module ApplicationHelper
  def paypal_payment_service_for(order, options = {}, &proc)
    payment_service_for(order, ActiveMerchant::Configuration.paypal_account, options.merge(:service => :paypal), &proc)
  end
end
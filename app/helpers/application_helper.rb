module ApplicationHelper
  def paypal_donation_service_for(order, options = {})
    payment_service_for(order, ActiveMerchant::Configuration.paypal_account, options.merge(:service => :paypal)) do |service|
      service.cmd = '_donations'
      yield service
    end
  end
end
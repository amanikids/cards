class Checkout::PayPalController < ApplicationController
  def create
    gateway.setup_purchase
  end

  private

  # TODO will need to use different credentials for different countries
  # TODO may need to extend PaypalExpressGateway for different countries
  def gateway
    ActiveMerchant::Billing::PaypalExpressGateway.new(
      :login     => ENV['PAYPAL_LOGIN'],
      :password  => ENV['PAYPAL_PASSWORD'],
      :signature => ENV['PAYPAL_SIGNATURE']
    )
  end
end

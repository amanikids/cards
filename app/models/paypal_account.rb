class PaypalAccount < ActiveRecord::Base
  attr_accessible :login
  attr_accessible :password
  attr_accessible :signature

  validates :login,     :presence => true
  validates :password,  :presence => true
  validates :signature, :presence => true

  def setup_purchase(amount, options={})
    gateway.setup_purchase(amount, options)
  end

  def redirect_url_for(token)
    gateway.redirect_url_for(token)
  end

  def details_for(token)
    gateway.details_for(token)
  end

  def purchase(amount, options={})
    gateway.purchase(amount, options)
  end

  private

  def gateway
    @gateway ||= ActiveMerchant::Billing::PaypalExpressGateway.new(
      attributes.slice(*%w(login password signature)).symbolize_keys!
    )
  end
end
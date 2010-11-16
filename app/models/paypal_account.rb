class PaypalAccount < ActiveRecord::Base
  has_one :store,
    :as => :account,
    :inverse_of => :account

  attr_accessible :login
  attr_accessible :password
  attr_accessible :signature

  validates :login,     :presence => true
  validates :password,  :presence => true
  validates :signature, :presence => true

  def setup_purchase(amount, options={})
    gateway.setup_purchase(amount, options.merge(:currency => store.currency, :description => 'Amani Holiday Cards'))
  end

  def redirect_url_for(token)
    gateway.redirect_url_for(token)
  end

  def details_for(token)
    gateway.details_for(token)
  end

  def purchase(amount, options={})
    gateway.purchase(amount, options.merge(:currency => store.currency))
  end

  def display_name
    login
  end

  def type_slash_id
    "#{self.class.name}/#{id}"
  end

  private

  def gateway
    @gateway ||= ActiveMerchant::Billing::PaypalExpressGateway.new(
      attributes.slice(*%w(login password signature)).symbolize_keys!
    )
  end
end

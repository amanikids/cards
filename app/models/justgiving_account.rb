class JustgivingAccount < ActiveRecord::Base
  has_one :store,
    :as => :account,
    :inverse_of => :account

  attr_accessible :charity_identifier

  validates :charity_identifier,
    :presence => true

  def redirect_url(params={})
    params.inject(redirect_url_base) do |url, (key, value)|
      url + "&#{key}=#{URI.escape(value.to_s)}"
    end
  end

  private

  def redirect_url_base
    "http://#{redirect_url_host}/donation/direct/charity/#{charity_identifier}?frequency=single"
  end

  def redirect_url_host
    'v3.staging.justgiving.com'
  end
end

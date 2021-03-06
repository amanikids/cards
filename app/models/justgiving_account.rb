class JustgivingAccount < ActiveRecord::Base
  DONATION_ID_KEY         = :donation_identifier
  DONATION_ID_PLACEHOLDER = 'JUSTGIVING-DONATION-ID'

  has_one :store,
    :as => :account,
    :inverse_of => :account

  attr_accessible :charity_identifier

  validates :charity_identifier,
    :presence => true

  def redirect_url(amount, return_url)
    URI::HTTP.build(
      :host  => redirect_url_host,
      :path  => redirect_url_path,
      :query => redirect_url_query(amount, append_donation_id(return_url))).to_s
  end

  def display_name
    charity_identifier
  end

  def type_slash_id
    "#{self.class.name}/#{id}"
  end

  private

  def redirect_url_host
    Rails.env.production? ? 'www.justgiving.com' : 'v3.staging.justgiving.com'
  end

  def redirect_url_path
    "/donation/direct/charity/#{charity_identifier}"
  end

  def redirect_url_query(amount_in_shillings, return_url)
    { :amount    => amount_in_shillings / 100,
      :exitUrl   => return_url,
      :frequency => 'single' }.to_query
  end

  def append_donation_id(url)
    "#{url}?#{DONATION_ID_KEY}=#{DONATION_ID_PLACEHOLDER}"
  end
end

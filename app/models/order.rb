class Order < ActiveRecord::Base
  belongs_to :cart
  belongs_to :payment, :polymorphic => true

  before_create :randomize_token

  def to_param
    token
  end

  private

  def randomize_token
    # http://www.apps.ietf.org/rfc/rfc4648.html#sec-5
    self.token = ActiveSupport::SecureRandom.base64(15).tr('+/=', '-_ ').strip
  end
end

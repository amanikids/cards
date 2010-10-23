class Order < ActiveRecord::Base
  belongs_to :cart
  belongs_to :payment, :polymorphic => true

  before_create :randomize_token

  def to_param
    token
  end

  private

  def randomize_token
    self.token = ActiveSupport::SecureRandom.base64url(15)
  end
end

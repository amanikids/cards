class User < ActiveRecord::Base
  attr_accessible :email, :password

  before_validation :downcase_email

  validates :email,
    :presence   => true,
    :uniqueness => true

  before_save :randomize_password_recovery_token

  class << self
    def authenticate(email, password)
      user = find_by_email(email.downcase)
      user if user && user.password == password
    end
  end

  def password
    BCrypt::Password.new(password_hash)
  end

  def password=(password)
    unless password.blank?
      self.password_hash = BCrypt::Password.create(password)
    end
  end

  def randomize_password!
    self.password = ActiveSupport::SecureRandom.hex(64)
    self.save!
  end

  private

  def downcase_email
    self.email = self.email.to_s.downcase
  end

  def randomize_password_recovery_token
    # http://www.apps.ietf.org/rfc/rfc4648.html#sec-5
    self.password_recovery_token = ActiveSupport::SecureRandom.base64(15).tr('+/=', '-_ ').strip
  end
end

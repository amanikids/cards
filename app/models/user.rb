class User < ActiveRecord::Base
  attr_accessible :email, :password

  before_validation :normalize_email

  validates :email,
    :presence   => true,
    :uniqueness => true

  before_save :randomize_password_recovery_token

  class << self
    def authenticate(email, password)
      find_by_email(email.downcase).try(:authenticate, password)
    end
  end

  def authenticate(password)
    hash_password(password) == password_hash ? self : nil
  end

  def password=(password)
    self.password_salt = ActiveSupport::SecureRandom.hex(64)
    self.password_hash = hash_password(password)
  end

  private

  def hash_password(password)
    Digest::SHA512.hexdigest("#{password_salt}::#{password}")
  end

  def normalize_email
    self.email = self.email.to_s.downcase
  end

  def randomize_password_recovery_token
    # http://www.apps.ietf.org/rfc/rfc4648.html#sec-5
    self.password_recovery_token = ActiveSupport::SecureRandom.base64(15).tr('+/=', '-_ ').strip
  end
end

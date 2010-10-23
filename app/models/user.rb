class User < ActiveRecord::Base
  composed_of :password_hash,
    :class_name => 'BCrypt::Password',
    :mapping    => %w(password_hash to_s)

  attr_accessible :email
  attr_accessible :password

  before_validation :downcase_email

  validates :email,
    :presence   => true,
    :uniqueness => true

  before_save :randomize_password_recovery_token

  class << self
    def authenticate(email, password)
      user = find_by_email(email.downcase)
      user if user && user.password_hash.is_password?(password)
    end
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
    self.password_recovery_token = ActiveSupport::SecureRandom.base64url(15)
  end
end

class User < ActiveRecord::Base
  validates_presence_of :email, :password
  validates_uniqueness_of :email
  validates_confirmation_of :password
  attr_protected :encrypted_password, :remember_me_token, :salt
  attr_accessor :password
  before_create :write_generated_login_tokens

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    user if user && user.send(:encrypt, password) == user.encrypted_password
  end

  private

  def digest(string)
    Digest::SHA1.hexdigest(string)
  end

  def encrypt(string)
    digest("--#{salt}--#{string}--")
  end

  def random_string
    Time.now.to_s.split(//).sort_by { rand }.join
  end

  def write_generated_login_tokens
    self.salt               = digest(random_string)
    self.encrypted_password = encrypt(password)
    self.remember_me_token  = encrypt(email)
  end
end

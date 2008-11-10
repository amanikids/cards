class User < ActiveRecord::Base
  has_digest :encrypted_password, :depends => :password

  validates_presence_of :email, :password
  validates_uniqueness_of :email
  validates_confirmation_of :password

  def self.authenticate(email, password)
    user = User.find_by_email(email)
    user if user && user.digest(user.salt, password) == user.encrypted_password
  end

  def distributor?
    type == 'Distributor'
  end

  def to_s
    name
  end
end

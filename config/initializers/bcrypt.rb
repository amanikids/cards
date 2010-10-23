require 'bcrypt'

class BCrypt::Password
  # Don't use == for comparisons with plaintext passwords. This way,
  # we can have an attribute compposed_of a BCrypt::Password and
  # make regular assumptions about equality changes in our tests.
  def ==(other)
    super
  end

  # Use is_password? to see if the given plaintext password matches.
  def is_password?(secret)
    self == BCrypt::Engine.hash_secret(secret, @salt)
  end
end

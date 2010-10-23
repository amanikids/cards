require 'bcrypt'

class BCrypt::Password
  # Don't use == for comparisons with plaintext passwords. This way,
  # we can have an attribute composed_of a BCrypt::Password and
  # make regular assumptions about equality changes in our tests.
  def ==(other)
    super
  end

  # Use is_password? to see if the given plaintext password matches.
  def is_password?(secret)
    self == BCrypt::Engine.hash_secret(secret, @salt)
  end

  # This way, we don't need a mapping when setting up aggregations. Those
  # mappings are always so confusing!
  alias :password_hash :to_s
end

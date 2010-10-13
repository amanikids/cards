%w( kathleen matthew ).each do |name|
  User.create!(
    :email    => "#{name}@amanikids.org",
    :password => Rails.env.development? ? 'secret' : ActiveSupport::SecureRandom.hex(64)
  )
end

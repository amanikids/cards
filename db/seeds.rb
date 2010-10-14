%w( kathleen matthew ).each do |name|
  User.create!(
    :email    => "#{name}@amanikids.org",
    :password => Rails.env.development? ? 'secret' : nil
  )
end

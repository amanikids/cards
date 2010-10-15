%w( kathleen matthew ).each do |name|
  User.find_or_create_by_email "#{name}@amanikids.org"
end

if Rails.env.development?
  require Rails.root.join('db', 'seeds', 'development')
end

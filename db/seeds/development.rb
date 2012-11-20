User.find_each do |user|
  user.update_attributes!(:password => 'password')
end

Product.find_or_initialize_by_name('Poinsettia').tap do |card|
  card.update_attributes!(:price => 10)
end

User.find_each do |user|
  user.update_attributes!(:password => 'secret')
end

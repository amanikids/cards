%w( kathleen matthew ).each do |name|
  User.find_or_initialize_by_email("#{name}@amanikids.org").tap do |user|
    user.randomize_password! if user.new_record?

    unless user.administrator?
      Administratorship.new.tap do |admin|
        admin.user = user
        admin.save!
      end
    end
  end
end

if Rails.env.development?
  require Rails.root.join('db', 'seeds', 'development')
end

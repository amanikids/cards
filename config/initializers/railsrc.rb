if Rails.env.development? || Rails.env.test?
  railsrc = "#{ENV['HOME']}/.railsrc"
  load(railsrc) if File.exist?(railsrc)
end

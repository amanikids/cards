if File.exists?("#{RAILS_ROOT}/vendor/bundle/environment.rb")
  require "#{RAILS_ROOT}/vendor/bundle/environment"
end

if File.exists?("#{RAILS_ROOT}/config/variables.rb")
  require "#{RAILS_ROOT}/config/variables"
end

this_rakefile_uses_shoe = <<END
----------------------------------------
Please install Shoe:
gem sources --add http://gems.github.com
gem install matthewtodd-shoe
----------------------------------------
END

begin
  gem 'matthewtodd-shoe'
rescue Gem::LoadError
  abort this_rakefile_uses_shoe
else
  require 'shoe'
end

Shoe.tie('has_digest', '0.1.3', 'ActiveRecord macro that helps encrypt passwords and generate api tokens before_save.') do |spec|
  spec.add_development_dependency 'thoughtbot-shoulda'
end

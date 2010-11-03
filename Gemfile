source :rubygems

gem 'cacheable_assets',
  :path    => 'vendor/extractions/cacheable_assets',
  :require => 'cacheable_assets/railtie'
gem 'graphite',
  :path    => 'vendor/extractions/graphite',
  :require => 'graphite/railtie'

gem 'activemerchant'
gem 'bcrypt-ruby', :require => 'bcrypt'
gem 'haml-rails'
gem 'heroku-environment'
gem 'pg'
gem 'rails'

group :development do
  gem 'autotest',       :require => false
  gem 'autotest-growl', :require => false
  gem 'heroku',         :require => false
end

# Include faker in :development so we can seed with lorem.
# Include rspec-rails in :development so we get `rake spec`.
group :development, :test do
  gem 'faker'
  gem 'rspec-rails'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'database_cleaner'
  gem 'machinist', '2.0.0.beta2'
  gem 'nokogiri'
  gem 'sham_rack'
  gem 'shoulda'
  gem 'sinatra', :require => 'sinatra/base'
  gem 'spork', '0.9.0.rc2'
end

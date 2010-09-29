source :rubygems

gem 'cacheable_assets',
  :path    => 'vendor/extractions/cacheable_assets',
  :require => 'cacheable_assets/railtie'

gem 'haml'
gem 'heroku-environment'
gem 'pg'
gem 'rails'

group :development do
  gem 'autotest', :require => false
  gem 'heroku',   :require => false
end

# Include rspec-rails in :development so we get `rake spec`.
group :development, :test do
  gem 'rspec-rails', '2.0.0.beta.22'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'machinist', '2.0.0.beta2'
end

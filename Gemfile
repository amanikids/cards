source :rubygems

gem 'rails', '2.3.5'

gem 'activemerchant',   '1.4.2', :require => 'active_merchant'
gem 'geoip',            '0.8.6'
gem 'haml',             '2.2.3'
gem 'hoptoad_notifier', '2.1.3', :require => 'hoptoad_notifier/rails'
gem 'money',            '2.1.5'
gem 'pg',               '0.9.0'
gem 'RedCloth',         '4.1.9', :require => 'redcloth'

group(:development) do
  gem 'heroku', '1.9.13', :require => false
end

group(:cucumber) do
  gem 'cucumber',    '0.3.103', :require => false
  gem 'webrat',      '0.5.0',   :require => false
  gem 'rspec',       '1.2.8',   :require => false
  gem 'rspec-rails', '1.2.7.1', :require => false

  gem 'factory_girl', '1.2.3'
  gem 'faker',        '0.3.1'
end

group(:test) do
  gem 'factory_girl', '1.2.3'
  gem 'faker',        '0.3.1'
  gem 'mocha',        '0.9.8',  :require => false
  gem 'redgreen',     '1.2.2',  :require => false
  gem 'shoulda',      '2.10.2'
end

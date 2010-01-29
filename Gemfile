bundle_path 'vendor/bundle'

gem 'rails', '2.3.5'

gem 'activemerchant',   '1.4.2', :require_as => 'active_merchant'
gem 'geoip',            '0.8.6'
gem 'haml',             '2.2.3'
gem 'hoptoad_notifier', '2.1.3', :require_as => 'hoptoad_notifier/rails'
gem 'money',            '2.1.5'
gem 'RedCloth',         '4.1.9', :require_as => 'redcloth'

only(:cucumber) do
  gem 'cucumber',    '0.3.103', :require_as => false
  gem 'webrat',      '0.5.0',   :require_as => false
  gem 'rspec',       '1.2.8',   :require_as => false
  gem 'rspec-rails', '1.2.7.1', :require_as => false

  gem 'factory_girl', '1.2.3'
  gem 'faker',        '0.3.1'
end

only(:test) do
  gem 'factory_girl', '1.2.3'
  gem 'faker',        '0.3.1'
  gem 'matchy',       '0.3.1',  :git => 'git://github.com/jm/matchy.git', :ref => '2e01918ad8d601685386aa9ac5d547ffb9b70b27'
  gem 'mocha',        '0.9.8'
  gem 'redgreen',     '1.2.2',  :require_as => false
  gem 'shoulda',      '2.10.2'
end

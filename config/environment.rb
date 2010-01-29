RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [:active_resource]
  config.time_zone = 'UTC'
  config.active_record.observers = :inventory_cache_observer, :notification_observer
end

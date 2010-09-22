RAILS_GEM_VERSION = '2.3.9' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.frameworks -= [:active_resource]
  config.time_zone = 'UTC'
  config.active_record.observers = :inventory_cache_observer, :notification_observer

  # Help on bandwidth.
  config.middleware.use 'Rack::Deflater'

  # Set far-future caching headers for static assets.
  config.middleware.use 'Rack::StaticCache',
    :root => 'public',
    :urls => ['/images', '/javascripts']

  # Serve sass-generated stylesheets on Heroku.
  config.middleware.use 'Rack::StaticCache',
    :root => 'tmp',
    :urls => ['/stylesheets']
end

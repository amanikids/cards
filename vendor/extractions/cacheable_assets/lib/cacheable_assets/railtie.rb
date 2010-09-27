require 'cacheable_assets'
require 'rails'
require 'rack/contrib'

module CacheableAssets
  class Railtie < Rails::Railtie
    config.app_middleware.use Rack::StaticCache,
      :root => 'public',
      :urls => ['/images', '/javascripts']
  end
end

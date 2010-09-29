require 'cacheable_assets'
require 'rails'

module CacheableAssets
  class Railtie < Rails::Railtie
    initializer :cacheable_assets, :before => :build_middleware_stack do
      require 'cacheable_assets/heroku' if defined?(Heroku)
      CacheableAssets.install_asset_path(config.action_controller, Rails.cache)
      CacheableAssets.install_middleware(config.app_middleware)
    end
  end
end

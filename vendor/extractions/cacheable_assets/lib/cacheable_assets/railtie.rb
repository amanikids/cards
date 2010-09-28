require 'cacheable_assets'
require 'rails'

module CacheableAssets
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      app.config.action_controller.asset_path = PathRewriter.new(CacheableAssets.configuration)
      app.middleware.use Middleware, CacheableAssets.configuration
    end
  end
end

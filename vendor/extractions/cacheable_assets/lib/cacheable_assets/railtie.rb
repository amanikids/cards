require 'cacheable_assets'
require 'rails'

module CacheableAssets
  class Railtie < Rails::Railtie
    config.after_initialize do |app|
      # Rewrite asset_paths to include an MD5 digest fingerprint.
      config.action_controller.asset_path =
        CacheableAssets.config.path_rewriter(Rails.cache)

      # Serve cacheable assets with far-future expiration times.
      app.middleware.use CacheableAssets.config.middleware
    end
  end
end

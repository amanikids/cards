require 'cacheable_assets'
require 'rails'

module CacheableAssets
  class Railtie < Rails::Railtie
    # Rewrite asset_paths to include an MD5 digest fingerprint.
    config.after_initialize do |app|
      app.config.action_controller.asset_path =
        CacheableAssets.path_rewriter(Rails.cache)
    end

    # Disable Heroku's static asset caching.
    config.after_initialize do
      require 'cacheable_assets/heroku' if defined?(Heroku)
    end

    # Serve cacheable assets with far-future expiration times.
    config.after_initialize do |app|
      app.middleware.use CacheableAssets.middleware
    end
  end
end

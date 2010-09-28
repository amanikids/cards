require 'cacheable_assets'
require 'rails'

module CacheableAssets
  class Railtie < Rails::Railtie

    config.after_initialize do |app|
      # Rewrite asset_paths to include an MD5 digest fingerprint.
      config.action_controller.asset_path = PathRewriter.new(
        CacheableAssets.config.finder,
        CacheableAssets.config.fingerprinter
      )

      # Serve cacheable assets with far-future expiration times.
      app.middleware.use Middleware, CacheableAssets.config.static_asset_paths
    end
  end
end

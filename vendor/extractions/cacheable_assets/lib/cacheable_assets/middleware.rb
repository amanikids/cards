require 'rack/contrib'

module CacheableAssets
  class Middleware
    def initialize(app, config)
      @app = config.static_asset_paths.inject(app) do |app, (root, urls)|
        Rack::StaticCache.new(app,
          :root => Rails.root.join(root),
          :urls => Array(urls)
        )
      end
    end

    def call(env)
      @app.call(env)
    end
  end
end

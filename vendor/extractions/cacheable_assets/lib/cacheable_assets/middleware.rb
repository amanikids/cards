require 'rack/contrib'

module CacheableAssets
  class Middleware
    def initialize(app, static_asset_paths)
      @app = build(app, static_asset_paths)
    end

    def call(env)
      @app.call(env)
    end

    private

    def build(app, static_asset_paths)
      static_asset_paths.inject(app) do |app, (root, urls)|
        Rack::StaticCache.new(app, :root => root, :urls => Array(urls))
      end
    end
  end
end

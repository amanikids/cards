module CacheableAssets
  class Configuration
    DEFAULT_STATIC_ASSET_PATHS = {
      'public' => %w( /favicon.ico /images /javascripts /stylesheets )
    }

    attr_reader :static_asset_paths

    def initialize
      @static_asset_paths = DEFAULT_STATIC_ASSET_PATHS.dup
    end

    def middleware
      MiddlewareBuilder.new(@static_asset_paths)
    end

    def path_rewriter(cache=nil)
      PathRewriter.new(
        Finder.new(@static_asset_paths),
        Cacher.new(Fingerprinter.new, cache)
      )
    end

    private

    class MiddlewareBuilder
      def initialize(static_asset_paths)
        @static_asset_paths = static_asset_paths
      end

      def new(app)
        Middleware.new(app, @static_asset_paths)
      end
    end
  end
end

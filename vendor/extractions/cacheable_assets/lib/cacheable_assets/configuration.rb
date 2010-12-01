module CacheableAssets
  class Configuration
    DEFAULT_STATIC_ASSET_PATHS = {
      'public' => %w( /favicon.ico /images /javascripts /stylesheets )
    }

    def initialize
      @static_asset_paths = DEFAULT_STATIC_ASSET_PATHS.dup
    end

    def configure(&block)
      block.call(@static_asset_paths)
    end

    def install_asset_path(controller, cache=nil)
      controller.asset_path = path_rewriter(cache)
    end

    def install_middleware(stack)
      stack.insert_after(ActionDispatch::Static, Middleware, @static_asset_paths)
    end

    private

    def path_rewriter(cache)
      PathRewriter.new(
        Finder.new(@static_asset_paths),
        Cacher.new(Fingerprinter.new, cache)
      )
    end
  end
end

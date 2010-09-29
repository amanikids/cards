require 'cacheable_assets/version'

module CacheableAssets
  autoload :Cacher,        'cacheable_assets/cacher'
  autoload :Configuration, 'cacheable_assets/configuration'
  autoload :Finder,        'cacheable_assets/finder'
  autoload :Fingerprinter, 'cacheable_assets/fingerprinter'
  autoload :Middleware,    'cacheable_assets/middleware'
  autoload :PathRewriter,  'cacheable_assets/path_rewriter'

  class << self
    def configure(&block)
      configuration.configure(&block)
    end

    def install_asset_path(controller, cache=nil)
      configuration.install_asset_path(controller, cache)
    end

    def install_middleware(stack)
      configuration.install_middleware(stack)
    end

    private

    def configuration
      @configuration ||= Configuration.new
    end
  end
end

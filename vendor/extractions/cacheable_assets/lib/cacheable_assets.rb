require 'cacheable_assets/version'

module CacheableAssets
  autoload :Cacher,        'cacheable_assets/cacher'
  autoload :Configuration, 'cacheable_assets/configuration'
  autoload :Finder,        'cacheable_assets/finder'
  autoload :Fingerprinter, 'cacheable_assets/fingerprinter'
  autoload :Middleware,    'cacheable_assets/middleware'
  autoload :PathRewriter,  'cacheable_assets/path_rewriter'

  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield configuration
    end

    def middleware
      configuration.middleware
    end

    def path_rewriter(cache=nil)
      configuration.path_rewriter(cache)
    end
  end
end

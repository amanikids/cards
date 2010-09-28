require 'cacheable_assets/version'

module CacheableAssets
  autoload :Cacher,        'cacheable_assets/cacher'
  autoload :Configuration, 'cacheable_assets/configuration'
  autoload :Finder,        'cacheable_assets/finder'
  autoload :Fingerprinter, 'cacheable_assets/fingerprinter'
  autoload :Middleware,    'cacheable_assets/middleware'
  autoload :PathRewriter,  'cacheable_assets/path_rewriter'

  class << self
    def config
      @config ||= Configuration.new
    end
  end
end

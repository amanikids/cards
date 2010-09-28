require 'cacheable_assets/version'

module CacheableAssets
  autoload :Configuration, 'cacheable_assets/configuration'
  autoload :Middleware,    'cacheable_assets/middleware'
  autoload :PathRewriter,  'cacheable_assets/path_rewriter'

  class << self
    def configuration
      @configuration ||= Configuration.new
    end
  end
end

module CacheableAssets
  class PathRewriter
    def initialize(finder, fingerprinter)
      @finder        = finder
      @fingerprinter = fingerprinter
    end

    def call(source)
      if path = @finder.call(source)
        rewrite(source, @fingerprinter.call(path))
      else
        source
      end
    end

    private

    # Insert the asset id in the filename, rather than in the query string. In
    # addition to looking nicer, this also keeps any other static file handlers
    # from preempting our Rack::StaticCache middleware, since these
    # version-numbered files don't actually exist on disk.
    def rewrite(source, fingerprint)
      source.insert(source.rindex('.'), "-#{fingerprint}")
    end
  end
end

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

    def rewrite(source, fingerprint)
      source.insert(source.rindex('.'), "-#{fingerprint}")
    end
  end
end

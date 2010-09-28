module CacheableAssets
  class PathRewriter
    def initialize(config)
      @config = config
    end

    def call(source)
      if path = @config.full_path_for(source)
        rewrite(source, fingerprint(path))
      else
        source
      end
    end

    private

    def rewrite(source, fingerprint)
      source.insert(source.rindex('.'), "-#{fingerprint}")
    end

    # We to_i(16) the digest since Rack::StaticCache assumes version numbers
    # have digits and dots only.
    def fingerprint(path)
      Digest::MD5.file(path).hexdigest.to_i(16)
    end
  end
end

require 'digest/md5'

module CacheableAssets
  class Fingerprinter
    # We to_i(16) the digest since Rack::StaticCache assumes version numbers
    # have digits and dots only.
    def call(path)
      Digest::MD5.file(path).hexdigest.to_i(16).to_s
    end
  end
end

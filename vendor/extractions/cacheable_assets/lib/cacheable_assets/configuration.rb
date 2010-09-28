module CacheableAssets
  class Configuration
    DEFAULT_STATIC_ASSET_PATHS = {
      'public' => %w( /images /javascripts )
    }

    attr_accessor :fingerprinter
    attr_reader   :static_asset_paths

    def initialize
      @fingerprinter      = Fingerprinter::MD5.new
      @static_asset_paths = DEFAULT_STATIC_ASSET_PATHS.dup
    end

    def finder
      Finder.new(@static_asset_paths)
    end
  end
end

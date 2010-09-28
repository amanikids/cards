module CacheableAssets
  class Configuration
    DEFAULT_STATIC_ASSET_PATHS = {
      'public' => %w( /images /javascripts )
    }

    attr_reader :static_asset_paths

    def initialize
      @static_asset_paths = DEFAULT_STATIC_ASSET_PATHS.dup
    end

    def full_path_for(source)
      if root = directory_root_for(source)
        File.join(root, source)
      end
    end

    private

    def directory_root_for(source)
      root, urls = configuration_for(source)
      root
    end

    def configuration_for(source)
      @static_asset_paths.find do |root, urls|
        urls.any? { |url| source.start_with?(url) }
      end
    end
  end
end

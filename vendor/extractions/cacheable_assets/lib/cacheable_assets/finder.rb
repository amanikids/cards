module CacheableAssets
  class Finder
    def initialize(static_asset_paths)
      @static_asset_paths = static_asset_paths
    end

    def call(source)
      if path = filesystem_path_for(source)
        path if File.exist?(path)
      end
    end

    private

    def filesystem_path_for(source)
      root, urls = configuration_for(source)
      File.join(root, source) if root
    end

    def configuration_for(source)
      @static_asset_paths.find do |root, urls|
        urls.any? { |url| source.start_with?(url) }
      end
    end
  end
end

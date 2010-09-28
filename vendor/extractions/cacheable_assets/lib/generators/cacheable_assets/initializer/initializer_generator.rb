module CacheableAssets
  module Generators
    class InitializerGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_initializer_file
        template 'initializer.rb',
                 'config/initializers/cacheable_assets.rb'
      end
    end
  end
end

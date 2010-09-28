module CacheableAssets
  module Generators #:nodoc:
    class InitializerGenerator < Rails::Generators::Base #:nodoc:
      source_root File.expand_path('../templates', __FILE__)

      def create_initializer_file
        template 'initializer.rb',
                 'config/initializers/cacheable_assets.rb'
      end
    end
  end
end

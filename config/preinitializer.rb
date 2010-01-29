if File.exists?("#{RAILS_ROOT}/config/variables.rb")
  require "#{RAILS_ROOT}/config/variables"
end

require "#{RAILS_ROOT}/vendor/bundle/environment"

# http://docs.heroku.com/gems#gem-bundler
class Rails::Boot
  def run
    load_initializer
    extend_environment
    Rails::Initializer.run(:set_load_path)
  end

  def extend_environment
    Rails::Initializer.class_eval do
      old_load = instance_method(:load_environment)
      define_method(:load_environment) do
      Bundler.require_env RAILS_ENV
        old_load.bind(self).call
      end
    end
  end
end

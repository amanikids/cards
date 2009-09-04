ENV['RAILS_ENV'] = 'test'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
require 'test_help'
require File.expand_path(File.dirname(__FILE__) + '/factories')
require 'mocha'

# Running from rake, if we just require 'shoulda', shoulda sees the Spec
# constant defined by Cucumber (loaded in lib/tasks/testing.rake) and thinks
# it should run in RSpec mode instead of Test::Unit mode. Bad shoulda.
require 'shoulda/test_unit'
require 'shoulda/rails'

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

# Load shoulda_macros from non-vendored gems:
Rails.configuration.gems.reject { |gem| gem.vendor_gem? }.map { |gem| gem.specification.full_gem_path }.each do |path|
  Shoulda.autoload_macros(File.dirname(path), File.basename(path))
end

ENV['RAILS_ENV'] = 'test'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
require 'test_help'
require File.expand_path(File.dirname(__FILE__) + '/factories')
require 'mocha'

if $stdin.tty?
  require 'redgreen'
end

class ActiveSupport::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false
end

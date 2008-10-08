ENV['RAILS_ENV'] = 'test'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
require 'test_help'
require File.expand_path(File.dirname(__FILE__) + '/factories')

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  self.backtrace_silencers << :rails_vendor
  self.backtrace_filters   << :rails_root

  def stub_login
    @request.session[:user] = 42
    User.stubs(:find).with(42).returns(stub(:id => 42, :email => 'email'))
  end
end

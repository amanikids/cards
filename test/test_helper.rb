ENV['RAILS_ENV'] = 'test'
require File.expand_path(File.dirname(__FILE__) + '/../config/environment')
require 'test_help'
require File.expand_path(File.dirname(__FILE__) + '/factories')

class Test::Unit::TestCase
  self.use_transactional_fixtures = true
  self.use_instantiated_fixtures  = false

  self.backtrace_silencers << :rails_vendor
  self.backtrace_filters   << :rails_root

  def stub_current_user
    returning stub(:id => 42, :email => 'email') do |user|
      @controller.current_user = user
      User.stubs(:find).with(user.id).returns(user)
    end
  end
end

require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  should_route :get, '/signup', :action => 'new'
end

require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  should_route :post, '/payments', :action => 'create'
end

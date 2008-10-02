require 'test_helper'

class CardsControllerTest < ActionController::TestCase
  should_route :get, '/', :action => 'index'
  
  context 'the index action' do
    setup { get :index }
    
    should_respond_with :success
    should_render_with_layout
  end
end

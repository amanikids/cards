require 'test_helper'

class DistributorsControllerTest < ActionController::TestCase
  should_route :get, '/distributors', :action => 'index'

  context 'index' do
    setup { get :index }
    should_redirect_to 'new_session_path'
  end

  context 'logged in' do
    setup { @controller.current_user = Factory.create(:user) }

    context 'index' do
      setup { get :index }
      should_render_template :index
    end
  end
end

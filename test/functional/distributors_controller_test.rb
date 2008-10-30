require 'test_helper'

class DistributorsControllerTest < ActionController::TestCase
  should_route :get, '/distributors',    :action => 'index'
  should_route :get, '/distributors/us', :action => 'show', :id => 'us'

  context 'not logged in' do
    context 'index' do
      setup { get :index }
      should_redirect_to 'new_session_path'
    end

    context 'show' do
      setup { get :show, :id => 'ID' }
      should_redirect_to 'new_session_path'
    end
  end

  context 'logged in' do
    setup { @controller.current_user = Factory(:user) }

    context 'index' do
      setup { get :index }
      should_render_template :index
    end

    context 'with an existing distributor' do
      setup { @distributor = Factory(:distributor) }

      context 'show' do
        setup { get :show, :id => @distributor.to_param }
        should_assign_to :distributor, :equals => '@distributor'
      end
    end
  end
end

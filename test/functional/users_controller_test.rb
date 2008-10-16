require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  should_route :get,  '/signup', :action => 'new'
  should_route :post, '/signup', :action => 'create'

  context 'new' do
    setup { get :new }
    should_assign_to :user
    should_not_assign_to :current_user
    should_render_template :new
    should_render_with_layout 'sessions'
  end

  context 'create' do
    context 'SUCCESS' do
      setup { User.stubs(:new).with(:attributes).returns(stub(:id => 42, :save => true)) }

      context 'without return_to in the session' do
        setup { post :create, :user => :attributes }
        should_assign_to :current_user
        should_redirect_to 'root_path'
      end

      context 'with return_to in the session' do
        setup do
          @request.session[:return_to] = checkout_path
          post :create, :user => :attributes
        end
        should_assign_to :current_user
        should_redirect_to 'checkout_path'
      end
    end

    context 'FAILURE' do
      setup do
        User.any_instance.stubs(:save).returns(false)
        post :create
      end

      should_assign_to :user
      should_not_assign_to :current_user
      should_render_template :new
    end
  end
end

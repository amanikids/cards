require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  should_route :get,    '/login',  :action => :new
  should_route :post,   '/login',  :action => :create
  should_route :delete, '/logout', :action => :destroy

  context 'create' do
    setup { @login_parameters = { :email => 'email', :password => 'password' } }

    context 'existing user' do
      setup { @login_parameters.merge!(:existing => '1') }

      context 'SUCCESS' do
        setup { User.stubs(:authenticate).with('email', 'password').returns(stub(:id => 42)) }

        context 'without return_to in the session' do
          setup { post :create, @login_parameters }
          should_assign_to :current_user
          should_redirect_to 'root_path'
        end

        context 'with return_to in the session' do
          setup do
            @request.session[:return_to] = checkout_path
            post :create, @login_parameters
          end
          should_assign_to :current_user
          should_redirect_to 'checkout_path'
        end
      end

      context 'FAILURE' do
        setup do
          User.stubs(:authenticate).returns(nil)
          post :create, @login_parameters
        end

        should_not_assign_to :current_user
        should_render_template :new
      end
    end

    context 'new user' do
      setup { post :create, @login_parameters.merge(:existing => '0') }
      should_redirect_to 'hash_for_new_user_path(:user => { :email => "email" })'
    end
  end

  context 'destroy' do
    setup do
      stub_current_user
      delete :destroy
    end

    should_not_assign_to :current_user
    should_redirect_to 'root_path'
  end
end

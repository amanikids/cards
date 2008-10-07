require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  should_route :get,  '/login', :action => :new
  should_route :post, '/login', :action => :create

  context 'login' do
    context 'existing user' do
      setup do
        @parameters = { :email => 'email', :existing => '1', :password => 'password' }
      end

      context 'SUCCESS' do
        setup do
          @user = Factory.create(:user)
          User.stubs(:authenticate).with('email', 'password').returns(@user)
          post :create, @parameters
        end

        should_return_from_session :user_id, '@user.id'
        should_redirect_to 'root_path'
      end

      context 'FAILURE' do
        setup do
          User.stubs(:authenticate).returns(nil)
          post :create, @parameters
        end

        should_return_from_session :user_id, 'nil'
        should_render_template :new
      end
    end
  end
end

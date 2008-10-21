require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  should_route :get,    '/sessions/new', :action => 'new'
  should_route :post,   '/sessions',     :action => 'create'
  should_route :delete, '/sessions',     :action => 'destroy'

  context 'with an existing User' do
    setup { @user = Factory.create(:user) }

    context 'when User.authenticate succeeds' do
      setup { User.stubs(:authenticate).with('EMAIL', 'PASSWORD').returns(@user) }

      context 'create' do
        setup { post :create, :email => 'EMAIL', :password => 'PASSWORD' }
        should_change '@controller.current_user', :from => nil, :to => @user
        should_redirect_to 'orders_path'
      end
    end

    context 'when User.authenticate fails' do
      setup { User.stubs(:authenticate).with('EMAIL', 'PASSWORD').returns(false) }

      context 'create' do
        setup { post :create, :email => 'EMAIL', :password => 'PASSWORD' }
        should_not_change '@controller.current_user'
        should_render_template :new
      end
    end

    context 'logged in' do
      setup { @controller.current_user = @user }

      context 'destroy' do
        setup { delete :destroy }
        should_change '@controller.current_user', :to => nil
        should_redirect_to 'new_session_path'
      end
    end
  end
end

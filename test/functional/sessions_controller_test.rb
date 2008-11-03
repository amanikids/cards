require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  should_route :get,    '/session/new', :action => 'new'
  should_route :post,   '/session',     :action => 'create'
  should_route :delete, '/session',     :action => 'destroy'

  context 'with an existing User' do
    setup { @user = Factory(:user) }

    context 'when User.authenticate succeeds' do
      setup { User.stubs(:authenticate).with('EMAIL', 'PASSWORD').returns(@user) }

      context 'create' do
        setup { post :create, :email => 'EMAIL', :password => 'PASSWORD' }
        should_change '@controller.current_user', :from => nil, :to => @user
        should_redirect_to 'distributors_path'
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

  context 'with an existing Distributor' do
    setup { @distributor = Factory(:distributor) }

    context 'when User.authenticate succeeds' do
      setup { User.stubs(:authenticate).with('EMAIL', 'PASSWORD').returns(@distributor) }

      context 'create' do
        setup { post :create, :email => 'EMAIL', :password => 'PASSWORD' }
        should_change '@controller.current_user', :from => nil, :to => @distributor
        should_redirect_to 'distributor_path(@distributor)'
      end
    end
  end
end

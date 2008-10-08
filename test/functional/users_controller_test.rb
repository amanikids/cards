require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  should_route :get,  '/signup', :action => 'new'
  should_route :post, '/signup', :action => 'create'

  context 'new' do
    setup { get :new }
    should_assign_to :user
    should_render_template :new
    should_render_with_layout 'sessions'
  end

  context 'create' do
    context 'SUCCESS' do
      setup do
        User.stubs(:new).with(:attributes).returns(stub(:id => 42, :save => true))
        post :create, :user => :attributes
      end

      should_return_from_session :user_id, '42'
      should_redirect_to 'root_path'
    end

    context 'FAILURE' do
      setup do
        User.any_instance.stubs(:save).returns(false)
        post :create
      end

      should_assign_to :user
      should_render_template :new
      should_return_from_session :user_id, 'nil'
    end
  end
end

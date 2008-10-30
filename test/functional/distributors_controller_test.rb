require 'test_helper'

class DistributorsControllerTest < ActionController::TestCase
  should_route :get, '/distributors',    :action => 'index'
  should_route :get, '/distributors/us', :action => 'show', :id => 'us'
  should_route :put, '/distributors/us', :action => 'update', :id => 'us'

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

      context 'when update_inventories succeeds' do
        setup { Distributor.any_instance.stubs(:update_inventories).with(:inventory_attributes).returns(true) }
        context 'update' do
          setup { put :update, :inventories => :inventory_attributes, :id => @distributor.to_param }
          should_set_the_flash_to 'Inventory updated.'
          should_redirect_to 'distributor_path(@distributor)'
        end
      end

      context 'when update_inventories fails' do
        setup { Distributor.any_instance.stubs(:update_inventories).returns(false) }
        context 'update' do
          setup { put :update, :inventories => {}, :id => @distributor.to_param }
          should_render_template 'show'
        end
      end
    end
  end
end

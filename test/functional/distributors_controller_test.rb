require 'test_helper'

class DistributorsControllerTest < ActionController::TestCase
  should_route :get, '/distributors',    :action => 'index'
  should_route :get, '/distributors/us', :action => 'show', :id => 'us'
  should_route :put, '/distributors/us', :action => 'update', :id => 'us'

  context 'not logged in' do
    context 'index' do
      setup { get :index }
      should_redirect_to('the login page') { new_session_path }
    end

    context 'show' do
      setup { get :show, :id => 'ID' }
      should_redirect_to('the login page') { new_session_path }
    end
  end

  context 'logged in as admin' do
    setup { @controller.current_user = Factory(:user) }

    context 'index' do
      setup { get :index }
      should_render_template :index
    end

    context 'with an existing distributor' do
      setup { @distributor = Factory(:distributor) }

      context 'show' do
        setup { get :show, :id => @distributor.to_param }
        should_assign_to(:distributor) { @distributor }
      end

      context 'when update_inventories succeeds' do
        setup { Distributor.any_instance.stubs(:update_inventories).with(:inventory_attributes).returns(true) }
        context 'update' do
          setup { put :update, :inventories => :inventory_attributes, :id => @distributor.to_param }
          should_set_the_flash_to 'Inventory updated.'
          should_redirect_to('the distributor page') { distributor_path(@distributor) }
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

  context 'logged in as US distributor' do
    setup do
      @us_distributor = Factory(:distributor, :country_code => 'us')
      @controller.current_user = @us_distributor
    end

    context 'index' do
      setup { get :index }
      should_redirect_to('the US distributor page') { distributor_path(@us_distributor) }
    end

    context 'viewing and editing self' do
      context 'show' do
        setup { get :show, :id => @us_distributor.to_param }
        should_assign_to(:distributor) { @us_distributor }
      end

      context 'when update_inventories succeeds' do
        setup { Distributor.any_instance.stubs(:update_inventories).with(:inventory_attributes).returns(true) }
        context 'update' do
          setup { put :update, :inventories => :inventory_attributes, :id => @us_distributor.to_param }
          should_set_the_flash_to 'Inventory updated.'
          should_redirect_to('the distributor page') { distributor_path(@us_distributor) }
        end
      end

      context 'when update_inventories fails' do
        setup { Distributor.any_instance.stubs(:update_inventories).returns(false) }
        context 'update' do
          setup { put :update, :inventories => {}, :id => @us_distributor.to_param }
          should_render_template 'show'
        end
      end
    end

    context 'attempting to view and edit CA distributor' do
      setup { @ca_distributor = Factory(:distributor, :country_code => 'ca') }

      context 'show' do
        setup { get :show, :id => @ca_distributor.to_param }
        should_redirect_to('the US distributor page') { distributor_path(@us_distributor) }
      end

      context 'update' do
        setup { put :update, :inventories => :inventory_attributes, :id => @ca_distributor.to_param }
        should_redirect_to('the US distributor page') { distributor_path(@us_distributor) }
      end
    end
  end
end

require 'test_helper'

class CurrentCartsControllerTest < ActionController::TestCase
  should_route :get, '/checkout', :action => 'show'
  should_route :get, '/cart',     :action => 'edit'
  should_route :put, '/cart',     :action => 'update'

  context 'show' do
    context 'without a current cart' do
      setup { get :show }
      should_redirect_to 'root_path'
    end

    context 'with a current cart' do
      setup do
        @controller.current_cart = Order.new
        get :show
      end

      should_eventually 'do something'
    end
  end

  context 'edit' do
    context 'without a current cart' do
      setup { get :edit }
      should_redirect_to 'root_path'
    end

    context 'with a current cart' do
      setup do
        @controller.current_cart = Order.new
        get :edit
      end

      should_assign_to :cart
      should_render_template 'edit'
    end
  end

  context 'update' do
    context 'without a current cart' do
      setup { put :update }
      should_redirect_to 'root_path'
    end

    context 'with a current cart' do
      context 'SUCCESS' do
        setup do
          @controller.current_cart = Order.new
          @controller.current_cart.stubs(:update_items).with(:item_attributes).returns(true)
          put :update, :items => :item_attributes
        end

        should_assign_to :cart
        should_redirect_to 'edit_current_cart_path'
      end

      context 'FAILURE' do
        setup do
          @controller.current_cart = Order.new
          @controller.current_cart.stubs(:update_items).returns(false)
          put :update
        end

        should_assign_to :cart
        should_render_template 'edit'
      end
    end
  end
end

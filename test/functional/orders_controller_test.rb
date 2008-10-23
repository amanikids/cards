require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  should_route :get,  '/orders',       :action => 'index'
  should_route :get,  '/orders/new',   :action => 'new'
  should_route :post, '/orders',       :action => 'create'
  should_route :get,  '/orders/token', :action => 'show', :id => 'token'

  context 'with a current cart' do
    setup { @controller.current_cart = Factory.create(:cart) }

    context 'new' do
      setup { get :new }
      should_redirect_to 'root_path'
    end

    context 'with one item' do
      setup { @controller.current_cart.items << Factory.create(:item) }

      context 'new (with current currency set)' do
        setup { @controller.current_currency = 'GBP'; get :new }
        should_assign_to :order
        should('set Order currency to current_currency') { assert_equal 'GBP', assigns(:order).currency }
        should_render_template 'new'
      end

      context 'when save succeeds' do
        setup { Order.any_instance.stubs(:save).returns(true) }

        context 'create' do
          setup { post :create }
          should_redirect_to 'order_path(@cart)'
        end
      end

      context 'when save fails' do
        setup { Order.any_instance.stubs(:save).returns(false) }

        context 'create' do
          setup { post :create }
          should_render_template :new
        end
      end
    end
  end

  context 'with a saved Order' do
    setup { @order = Factory.create(:order) }
    context 'show' do
      setup { get :show, :id => @order.token }
      should_assign_to :order, :equals => '@order'
    end
  end

  context 'index' do
    setup { get :index }
    should_redirect_to 'new_session_path'
  end

  context 'logged in' do
    setup { @controller.current_user = Factory.create(:user) }

    context 'index' do
      setup { get :index }
      should_render_template :index
    end
  end
end

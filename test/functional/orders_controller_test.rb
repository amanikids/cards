require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  should_route :get,  '/orders',       :action => 'index'
  should_route :get,  '/checkout',     :action => 'new'
  should_route :post, '/checkout',     :action => 'create'
  should_route :get,  '/orders/token', :action => 'show', :id => 'token'

  context 'with a current cart' do
    setup do
      @cart = Factory.create(:cart)
      @controller.current_cart = @cart
    end

    context 'new' do
      setup { get :new }
      should_redirect_to 'root_path'
    end

    context 'with one item' do
      setup { @cart.items << Factory.create(:item) }
      context 'new' do
        setup { get :new }
        should_redirect_to 'new_address_path'
      end

      context 'with a shipping address' do
        setup { @cart.address = Factory.create(:address) }
        context 'new' do
          setup { get :new }
          should_assign_to :cart
          should_render_template 'new'
        end

        context 'create' do
          setup { post :create }
          should_change 'Cart.count', :by => -1
          should_change 'Order.count', :by => 1
          should_redirect_to 'order_path(@cart)'
          should_change '@controller.current_cart', :to => nil
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

  context 'logged in' do
    setup { @controller.current_user = Factory.create(:user) }

    context 'index' do
      setup { get :index }
      should_render_template :index
    end
  end

  context 'not logged in' do
    setup { @controller.current_user = nil }

    context 'index' do
      setup { get :index }
      should_redirect_to 'new_session_path'
    end
  end
end

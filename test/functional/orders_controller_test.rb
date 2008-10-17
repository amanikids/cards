require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  should_route :get,  '/checkout',       :action => 'new'
  should_route :post, '/checkout',       :action => 'create'
  should_route :get,  '/orders/bad32e6', :action => 'show', :id => 'bad32e6'

  context 'with a current cart' do
    setup { @controller.current_cart = Factory.create(:cart) }
    context 'new' do
      setup { get :new }
      should_redirect_to 'root_path'
    end

    context 'with one item' do
      setup { @controller.current_cart.items << Factory.create(:item) }
      context 'new' do
        setup { get :new }
        should_redirect_to 'new_address_path'
      end

      context 'with a shipping address' do
        setup { @controller.current_cart.address = Factory.create(:address) }
        context 'new' do
          setup { get :new }
          should_assign_to :order
          should_render_template 'new'
        end

        context 'create' do
          setup { post :create }
          before_should('confirm order') { @controller.current_cart.expects(:confirm!) }
          should_redirect_to 'order_path(:id => @controller.current_cart.token)'
        end
      end
    end
  end

  context 'with a saved order' do
    setup { @order = Factory.create(:order) }

    context 'show' do
      setup { get :show, :id => @order.token }
      should_assign_to :order, :equals => '@order'
      should_render_template :show
    end
  end
end

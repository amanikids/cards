require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  should_route :get,  '/checkout',       :action => 'new'

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
          should_assign_to :cart
          should_render_template 'new'
        end
      end
    end
  end
end

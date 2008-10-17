require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  should_route :get, '/checkout', :action => 'new'

  context 'without a current cart' do
    context 'new' do
      setup { get 'new' }
      should_redirect_to 'root_path'
    end
  end

  context 'with a non-blank current cart' do
    setup do
      @controller.current_cart = Factory.create(:cart)
      @controller.current_cart.items << Factory.create(:item)
    end

    context 'new' do
      setup { get 'new' }
      should_assign_to :order
      should_render_template 'new'
    end
  end
end

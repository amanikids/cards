require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  should_route :get, '/cart', :action => 'edit'
  should_route :put, '/cart', :action => 'update'

  context 'without a current cart' do
    context 'edit' do
      setup { get :edit }
      should_redirect_to 'root_path'
    end

    context 'update' do
      setup { put :update }
      should_redirect_to 'root_path'
    end
  end

  context 'with a current cart' do
    setup { @controller.current_cart = Factory.create(:cart) }

    context 'edit' do
      setup { get :edit }
      should_assign_to :cart
      should_render_template 'edit'
    end

    context 'when update_items succeeds' do
      setup { @controller.current_cart.stubs(:update_items).with(:item_attributes).returns(true) }
      context 'update' do
        setup { put :update, :items => :item_attributes }
        should_redirect_to 'edit_cart_path'
      end
    end

    context 'when update_items fails' do
      setup { @controller.current_cart.stubs(:update_items).returns(false) }
      context 'update' do
        setup { put :update, :items => {} }
        should_render_template 'edit'
      end
    end
  end
end

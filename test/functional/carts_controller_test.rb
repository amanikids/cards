require 'test_helper'

class CartsControllerTest < ActionController::TestCase
  should_route :get, '/us/cart', :action => 'show',   :distributor_id => 'us'
  should_route :put, '/us/cart', :action => 'update', :distributor_id => 'us'

  context 'with an existing Distributor' do
    setup { @distributor = Factory.create(:distributor) }

    context 'without a current cart' do
      context 'show' do
        setup { get :show, :distributor_id => @distributor.to_param }
        should_redirect_to 'distributor_root_path(@distributor)'
      end

      context 'update' do
        setup { put :update, :distributor_id => @distributor.to_param }
        should_redirect_to 'distributor_root_path(@distributor)'
      end
    end

    context 'with a non-empty current cart' do
      setup do
        @controller.current_cart = Factory.create(:cart)
        @controller.current_cart.items << Factory.create(:item)
      end

      context 'show' do
        setup { get :show, :distributor_id => @distributor.to_param }
        should_assign_to :cart
        should_render_template 'show'
      end

      context 'when update_items succeeds' do
        setup { @controller.current_cart.stubs(:update_items).with(:item_attributes).returns(true) }
        context 'update' do
          setup { put :update, :items => :item_attributes, :distributor_id => @distributor.to_param }
          should_set_the_flash_to 'Cart updated.'
          should_redirect_to 'cart_path(@distributor)'
        end
      end

      context 'when update_items fails' do
        setup { @controller.current_cart.stubs(:update_items).returns(false) }
        context 'update' do
          setup { put :update, :items => {}, :distributor_id => @distributor.to_param }
          should_render_template 'show'
        end
      end
    end
  end
end

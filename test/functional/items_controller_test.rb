require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  should_route :post,   '/us/cart/items',   :action => 'create', :distributor_id => 'us'
  should_route :delete, '/us/cart/items/1', :action => 'destroy', :distributor_id => 'us', :id => 1

  context 'with an existing Distributor' do
    setup { @distributor = Factory.create(:distributor) }

    context 'create' do
      context 'with a brand-new cart' do
        setup { post :create, :distributor_id => @distributor, :item => Factory.attributes_for(:item, :variant_id => Factory(:variant).id) }

        should_assign_to :current_cart
        should_change 'Cart.count', :by => 1
        should_change '@distributor.carts.count', :by => 1
        should_change 'Item.count', :by => 1
        should_redirect_to 'distributor_root_path(@distributor)'
      end

      context 'with an existing cart' do
        setup { @controller.current_cart = Cart.create }

        context 'posting valid attributes' do
          setup { post :create, :distributor_id => @distributor, :item => Factory.attributes_for(:item, :variant_id => Factory(:variant).id) }
          should_not_change 'Cart.count'
          should_change 'Item.count', :by => 1
          should_redirect_to 'distributor_root_path(@distributor)'
        end
      end
    end

    context 'with a current_cart' do
      setup { @controller.current_cart = Factory.create(:cart) }

      context 'with an item in the cart' do
        setup { @controller.current_cart.items << @item = Factory.create(:item) }

        context 'destroy' do
          setup { delete :destroy, :distributor_id => @distributor, :id => @item.id }
          should_change 'Item.count', :by => -1
          should_set_the_flash_to 'Item removed.'
          should_redirect_to 'cart_path(@distributor)'
        end
      end
    end
  end
end

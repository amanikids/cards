require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  should_route :post,   '/us/cart/items',   :action => 'create', :distributor_id => 'us'
  should_route :delete, '/us/cart/items/1', :action => 'destroy', :distributor_id => 'us', :id => 1

  context 'with an existing Distributor' do
    setup { @distributor = Factory.create(:distributor) }

    context 'create' do
      context 'with a brand-new cart' do
        setup { post :create, :distributor_id => @distributor.to_param, :item => Factory.attributes_for(:item, :variant_id => Factory(:variant).id) }

        should_assign_to :current_cart
        should_change('Cart.count', :by => 1) { Cart.count }
        should_change('@distributor.carts.count', :by => 1) { @distributor.carts.count }
        should_change('Item.count', :by => 1) { Item.count }
        should_redirect_to('the products page') { distributor_root_path(@distributor) }
      end

      context 'with an existing cart' do
        setup { @controller.current_cart = Cart.create }

        context 'posting valid attributes' do
          setup { post :create, :distributor_id => @distributor.to_param, :item => Factory.attributes_for(:item, :variant_id => Factory(:variant).id) }
          should_not_change('Cart.count') { Cart.count }
          should_change('Item.count', :by => 1) { Item.count }
          should_redirect_to('the products page') { distributor_root_path(@distributor) }
        end
      end
    end

    context 'with a current_cart' do
      setup { @controller.current_cart = Factory.create(:cart) }

      context 'with an item in the cart' do
        setup { @controller.current_cart.items << @item = Factory.create(:item) }

        context 'destroy' do
          setup { delete :destroy, :distributor_id => @distributor.to_param, :id => @item.id }
          should_change('Item.count', :by => -1) { Item.count }
          should_set_the_flash_to 'Item removed.'
          should_redirect_to('the cart page') { cart_path(@distributor) }
        end
      end
    end
  end
end

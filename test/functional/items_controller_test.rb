require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  should_route :post,   '/us/cart/items',   :action => 'create', :distributor_id => 'us'

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
  end
end

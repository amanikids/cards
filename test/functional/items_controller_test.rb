require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  should_route :post, '/items', :action => 'create'

  context 'create' do
    context 'with a brand-new cart' do
      setup { post :create, :item => Factory.attributes_for(:item, :variant_id => Factory(:variant).id) }

      should_assign_to :current_cart
      should_change 'Cart.count', :by => 1
      should_change 'Item.count', :by => 1
      should_redirect_to 'root_path'
    end

    context 'with an existing cart' do
      setup { @controller.current_cart = Cart.create }

      context 'posting valid attributes' do
        setup { post :create, :item => Factory.attributes_for(:item, :variant_id => Factory(:variant).id) }
        should_not_change 'Cart.count'
        should_change 'Item.count', :by => 1
        should_redirect_to 'root_path'
      end
    end
  end
end

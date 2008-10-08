require 'test_helper'

class ItemsControllerTest < ActionController::TestCase
  should_route :post, '/items', :action => 'create'

  context 'create' do
    context 'with a brand-new cart' do
      setup do
        post :create, :item => Factory.attributes_for(:item, :card_id => Factory(:card).id)
      end

      should_assign_to :current_cart
      should_change 'Order.count', :by => 1
      should_change 'Item.count', :by => 1
      should_redirect_to 'root_path'
    end

    context 'with an existing cart' do
      setup do
        @controller.current_cart = Order.create
        post :create, :item => Factory.attributes_for(:item, :card_id => Factory(:card).id)
      end

      should_change 'Order.count', :by => 1
    end
  end
end

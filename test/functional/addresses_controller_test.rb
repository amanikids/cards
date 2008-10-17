require 'test_helper'

class AddressesControllerTest < ActionController::TestCase
  should_route :get,  '/shipping', :action => 'new'
  should_route :post, '/shipping', :action => 'create'

  context 'with a current_cart' do
    setup { @controller.current_cart = Factory.create(:cart) }
    context 'new' do
      setup { get :new }
      should_redirect_to 'root_path'
    end

    context 'with one item' do
      setup { @controller.current_cart.items << Factory.create(:item) }
      context 'new' do
        setup { get :new }
        should_assign_to :address
        should_render_template :new
      end

      context 'with valid attributes' do
        setup { @attributes = Factory.attributes_for(:address) }
        context 'create' do
          setup { post :create, :address => @attributes }
          should_change 'Address.count'
          should_change '@controller.current_cart.reload.address', :from => nil
          should_redirect_to 'checkout_path'
        end
      end

      context 'with invalid attributes' do
        context 'create' do
          setup { post :create }
          should_not_change 'Address.count'
          should_not_change '@controller.current_cart.reload.address'
          should_render_template :new
        end
      end
    end
  end
end

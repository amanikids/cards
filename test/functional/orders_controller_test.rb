require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  should_route :get,  '/us/orders/new',   :action => 'new',    :distributor_id => 'us'
  should_route :post, '/us/orders',       :action => 'create', :distributor_id => 'us'
  should_route :get,  '/us/orders/token', :action => 'show',   :distributor_id => 'us', :id => 'token'

  context 'with a saved Distributor' do
    setup { @distributor = Factory.create(:distributor) }

    context 'with a current cart' do
      setup { @controller.current_cart = Factory.create(:cart) }

      context 'new' do
        setup { get :new, :distributor_id => @distributor.to_param }
        should_redirect_to 'distributor_root_path(@distributor)'
      end

      context 'with one item' do
        setup { @controller.current_cart.items << Factory.create(:item) }

        context 'new' do
          setup { get :new, :distributor_id => @distributor.to_param }
          should_assign_to :order
          should_render_template 'new'
        end

        context 'when save succeeds' do
          setup { Order.any_instance.stubs(:save).returns(true) }

          context 'create' do
            setup { post :create, :distributor_id => @distributor.to_param }
            should_redirect_to 'order_path(@distributor, @cart)'
            should_change 'Cart.count', :by => -1
            should_change '@controller.current_cart', :to => nil
          end
        end

        context 'when save fails' do
          setup { Order.any_instance.stubs(:save).returns(false) }

          context 'create' do
            setup { post :create, :distributor_id => @distributor.to_param }
            should_render_template :new
          end
        end
      end
    end

    context 'with a saved Order' do
      setup { @order = Factory.create(:order) }
      context 'show' do
        setup { get :show, :distributor_id => @distributor.to_param, :id => @order.token }
        should_assign_to :order, :equals => '@order'
      end
    end
  end
end
require File.join(File.dirname(__FILE__), '..', 'test_helper')

class OrdersControllerTest < ActionController::TestCase
  should_route :get,    '/us/orders/new',   :action => 'new',     :distributor_id => 'us'
  should_route :post,   '/us/orders',       :action => 'create',  :distributor_id => 'us'
  should_route :get,    '/us/orders/token', :action => 'show',    :distributor_id => 'us', :id => 'token'
  should_route :delete, '/us/orders/token', :action => 'destroy', :distributor_id => 'us', :id => 'token'

  context 'with a saved Distributor' do
    setup { @distributor = Factory.create(:distributor, :name => 'The Right Distributor') }

    context 'with a current cart' do
      setup do
        @controller.current_cart = Factory.create(:cart, :distributor => @distributor) 
      end

      context 'new' do
        setup { get :new, :distributor_id => @distributor.to_param }
        should_redirect_to('the products page') { distributor_root_path(@distributor) }
      end

      context 'with one item' do
        setup { @controller.current_cart.items << Factory.create(:item) }

        context 'new' do
          setup { get :new, :distributor_id => @distributor.to_param }
          should_assign_to :order
          should_render_template 'new'
        end

        context 'create valid' do
          setup do
            post :create, :distributor_id => @distributor.to_param, :order => { 
              :address => Factory.attributes_for(:address) }
            assert_response :redirect
          end

          should_redirect_to('the Order') { order_path(@distributor, @controller.instance_variable_get(:@order)) }
          should_change('Cart.count', :by => -1) { Cart.count }
          should_change('@controller.current_cart', :to => nil) { @controller.current_cart }
        end

        context 'create invalid' do
          setup { post :create, :distributor_id => @distributor.to_param }
          should_render_template :new
        end

        context 'create with malicious data' do
          setup do
            post :create, :distributor_id => @distributor.to_param, :order => { 
              :address        => Factory.attributes_for(:address),
              :token          => 'EVIL', 
              :distributor_id => Factory.create(:distributor).id}
          end

          should 'not change the token' do
            assert_not_equal assigns(:order).reload.token, 'EVIL'
          end

          should 'not change distributor' do
            assert_equal assigns(:order).reload.distributor, @distributor
          end
        end
      end
    end

    context 'with a saved Order' do
      setup { @order = Factory.create(:order, :distributor => @distributor) }

      context 'show' do
        setup { get :show, :distributor_id => @distributor.to_param, :id => @order.token }
        should_assign_to(:order) { @order }
      end

      context 'not logged in' do
        setup { @controller.current_user = nil }

        context 'destroy' do
          setup { delete :destroy, :distributor_id => @distributor.to_param, :id => @order.token }
          should_redirect_to('the login page') { new_session_path }
        end
      end

      context 'logged in' do
        setup { @controller.current_user = @distributor }

        context 'destroy' do
          setup { delete :destroy, :distributor_id => @distributor.to_param, :id => @order.token }
          should_change('Order.count', :by => -1) { Order.count }
          should_redirect_to('the distributor') { distributor_path(@distributor) }
        end
      end
    end
  end
end

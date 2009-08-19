require 'test_helper'

class ShipmentsControllerTest < ActionController::TestCase
  should_route :post,   '/us/orders/12345/shipment', :action => 'create',  :order_id => '12345', :distributor_id => 'us'
  should_route :delete, '/us/orders/12345/shipment', :action => 'destroy', :order_id => '12345', :distributor_id => 'us'

  context 'with an existing Distributor' do
    setup { @distributor = Factory.create(:distributor) }

    context 'with an existing Order' do
      setup { @order = Factory.create(:order) }

      context 'not logged in' do
        setup { @controller.current_user = nil }

        context 'create' do
          setup { post :create, :distributor_id => @distributor.to_param, :order_id => @order.token }
          should_redirect_to('the login page') { new_session_path }
        end

        context 'destroy' do
          setup { delete :destroy, :distributor_id => @distributor.to_param, :order_id => @order.token }
          should_redirect_to('the login page') { new_session_path }
        end
      end

      context 'logged in' do
        setup { @controller.current_user = Factory.create(:user) }

        context 'create' do
          setup { post :create, :distributor_id => @distributor.to_param, :order_id => @order.token }
          should_change '@order.reload.shipment', :from => nil
          should_change 'Shipment.count', :by => 1
          should_redirect_to('the order page') { order_path(@distributor, @order) }
        end

        context 'with an existing Shipment' do
          setup { @shipment = Factory(:shipment, :order => @order) }

          context 'destroy' do
            setup { delete :destroy, :distributor_id => @distributor.to_param, :order_id => @order.token }
            should_change '@order.reload.shipment'
            should_change 'Shipment.count', :by => -1
            should_redirect_to('the order page') { order_path(@distributor, @order) }
          end
        end
      end
    end
  end
end

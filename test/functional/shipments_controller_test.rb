require 'test_helper'

class ShipmentsControllerTest < ActionController::TestCase
  should_route :post, '/orders/12345/shipment', :action => 'create', :order_id => '12345'

  context 'with an existing Order' do
    setup { @order = Factory.create(:order) }

    context 'not logged in' do
      setup { @controller.current_user = nil }

      context 'create' do
        setup { post :create, :order_id => @order.token }
        should_redirect_to 'new_session_path'
      end
    end

    context 'logged in' do
      setup { @controller.current_user = Factory.create(:user) }

      context 'create' do
        setup { post :create, :order_id => @order.token }
        should_change '@order.reload.shipment', :from => nil
        should_change 'Shipment.count', :by => 1
        should('set shipper to current_user') { assert_equal @controller.current_user, @order.reload.shipper }
        should_set_the_flash_to 'Shipment created.'
        should_redirect_to 'order_path(@order)'
      end
    end
  end
end

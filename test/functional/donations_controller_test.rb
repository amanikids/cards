require 'test_helper'

class DonationsControllerTest < ActionController::TestCase
  should_route :post, '/us/orders/12345/donation', :action => 'create', :order_id => '12345', :distributor_id => 'us'
  should_route :put,  '/us/orders/12345/donation', :action => 'update', :order_id => '12345', :distributor_id => 'us'

  context 'with an existing Distributor' do
    setup { @distributor = Factory.create(:distributor) }

    context 'with an existing Order and DonationMethod' do
      setup do
        @order           = Factory.create(:order)
        @donation_method = Factory.create(:donation_method)
      end

      context 'create' do
        setup { post :create, :distributor_id => @distributor.to_param, :order_id => @order.token, :donation => { :donation_method_id => @donation_method.id }}
        should_change '@order.reload.donation', :from => nil
        should_change 'Donation.count', :by => 1

        should 'create donation with the request method' do
          assert_equal @donation_method, @order.donation.donation_method
        end

        should 'not mark donation as received' do
          assert_nil @order.donation.received_at
        end

        should_redirect_to 'order_path(@distributor, @order)'
      end
    end

    context 'with an existing Order and unreceived Donation' do
      setup { @donation = Factory.create(:donation, :received_at => nil) }

      context 'not logged in' do
        setup { @controller.current_user = nil }

        context 'update' do
          setup { put :update, :distributor_id => @distributor.to_param, :order_id => @donation.order.token, :donation => { :received_at => Time.now } }
          should_not_change '@donation.received_at'
          should_redirect_to 'new_session_path'
        end
      end

      context 'logged in' do
        setup { @controller.current_user = Factory.create(:user) }

        context 'update' do
          setup { put :update, :distributor_id => @distributor.to_param, :order_id => @donation.order.token, :donation => { :received_at => Time.now } }
          should_change '@donation.reload.received_at'
          should_set_the_flash_to 'Donation updated.'
          should_redirect_to 'order_path(@distributor, @order)'
        end
      end
    end
  end
end

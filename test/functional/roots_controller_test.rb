require 'test_helper'

class RootsControllerTest < ActionController::TestCase
  should_route :get, '/', :action => 'index'

  context 'with some existing Distributors' do
    setup do
      @custom_distributor  = Factory(:distributor, :country_code => 'CUSTOM')
      @default_distributor = Factory(:distributor, :country_code => 'DEFAULT')
      Distributor.stubs(:default).returns(@default_distributor)
    end

    context 'when our coutry_code is COUNTRY_CODE' do
      setup { Locator.service.stubs(:country_code).returns('COUNTRY_CODE') }

      context 'and we have a matching distributor' do
        setup { Distributor.stubs(:find_by_country_code).with('COUNTRY_CODE').returns(@custom_distributor) }
        context 'index' do
          setup { get :index }
          should_redirect_to 'distributor_root_path(@custom_distributor)'
        end
      end

      context "but we don't have a matching distributor" do
        setup { Distributor.stubs(:find_by_country_code).with('COUNTRY_CODE').returns(nil) }
        context 'index' do
          setup { get :index }
          should_redirect_to 'distributor_root_path(@default_distributor)'
        end
      end
    end
  end
end

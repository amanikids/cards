require File.join(File.dirname(__FILE__), '..', 'test_helper')

class RootsControllerTest < ActionController::TestCase
  should_route :get, '/', :action => 'index'

  context 'with US and UK Distributors' do
    setup do
      @us_distributor = Factory(:distributor, :country_code => 'us')
      @uk_distributor = Factory(:distributor, :country_code => 'uk')
    end

    context 'requesting from a US IP address' do
      setup do
        @request.stubs(:remote_ip).returns('8.12.42.230')
        get :index
      end

      should_redirect_to('the US distributor') do
        distributor_root_path(@us_distributor)
      end
    end

    context 'requesting from a UK IP address' do
      setup do
        @request.stubs(:remote_ip).returns('212.58.224.138')
        get :index
      end

      should_redirect_to('the UK distributor') do
        distributor_root_path(@uk_distributor)
      end
    end

    context 'requesting from an AU IP address' do
      setup do
        @request.stubs(:remote_ip).returns('120.100.2.230')
        get :index
      end

      should_redirect_to('the UK distributor (the default)') do
        distributor_root_path(@uk_distributor)
      end
    end
  end
end

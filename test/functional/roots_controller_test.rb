require 'test_helper'

class RootsControllerTest < ActionController::TestCase
  should_route :get, '/', :action => 'index'

  context 'with an exisitng distributor' do
    setup do
      @distributor = Factory.create(:distributor)
      Distributor.stubs(:default).returns(@distributor)
    end

    context 'index' do
      setup { get :index }
      should_redirect_to 'distributor_root_path(@distributor)'
    end
  end
end

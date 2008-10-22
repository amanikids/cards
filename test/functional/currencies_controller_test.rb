require 'test_helper'

class CurrenciesControllerTest < ActionController::TestCase
  should_route :post, '/currencies/GBP', :action => 'create', :currency => 'GBP'
  should_route :post, '/currencies/USD', :action => 'create', :currency => 'USD'

  context 'create' do
    setup { post :create, :currency => 'GBP' }
    should_change '@controller.current_currency', :to => 'GBP'
    should_redirect_to 'root_path'
  end
end

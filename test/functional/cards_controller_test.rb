require 'test_helper'

class CardsControllerTest < ActionController::TestCase
  context 'GET index' do
    context 'logged in' do
      setup do
        stub_login
        get :index
      end

      should_assign_to :current_user
    end
  end
end

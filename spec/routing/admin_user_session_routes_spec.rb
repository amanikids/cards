require 'spec_helper'

describe 'routes to the admin user_sessions controller' do
  it 'routes GET new' do
    { :get => admin_new_user_session_path }.should(
      route_to(
        :controller => 'admin/user_sessions',
        :action     => 'new'
      )
    )
  end

  it 'routes POST create' do
    { :post => admin_user_sessions_path }.should(
      route_to(
        :controller => 'admin/user_sessions',
        :action     => 'create'
      )
    )
  end

  it 'routes GET destroy' do
    { :get => admin_destroy_user_session_path }.should(
      route_to(
        :controller => 'admin/user_sessions',
        :action     => 'destroy'
      )
    )
  end
end

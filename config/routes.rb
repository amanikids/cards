ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'roots'

  map.resource :session
  map.resources :distributors
  map.resources :batches

  map.with_options(:path_prefix => '/:distributor_id') do |map|
    map.root :controller => 'products', :name_prefix => 'distributor_'
    map.resource :cart, :has_many => :items
    map.resources :orders,
      :member  => {:transfer => :put},
      :has_one => [:donation, :paypal_donation, :shipment]
  end
end

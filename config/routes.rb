ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'products'

  map.resource :cart, :session

  map.resources :downloads, :items
  map.resources :orders do |order|
    order.resource :donation, :paypal_donation, :shipment
  end
end

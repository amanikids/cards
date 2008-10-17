ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'products'

  map.with_options(:controller => 'carts') do |map|
    map.edit_cart '/cart', :action => 'edit',   :conditions => { :method => :get }
    map.cart      '/cart', :action => 'update', :conditions => { :method => :put }
  end

  map.with_options(:controller => 'items') do |map|
    map.items '/items', :action => 'create', :conditions => { :method => :post }
  end
end

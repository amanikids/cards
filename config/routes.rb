ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'products'

  map.with_options(:controller => 'current_carts') do |map|
    map.checkout          '/checkout', :action => 'show',   :conditions => { :method => :get }
    map.edit_current_cart '/cart',    :action => 'edit',    :conditions => { :method => :get }
    map.current_cart      '/cart',    :action => 'update',  :conditions => { :method => :put }
  end

  map.with_options(:controller => 'items') do |map|
    map.items     '/items',   :action => 'create',  :conditions => { :method => :post }
  end
end

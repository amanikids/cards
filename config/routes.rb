ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'products'

  map.with_options(:controller => 'addresses') do |map|
    map.new_address '/shipping', :action => 'new',    :conditions => { :method => :get }
    map.addresses   '/shipping', :action => 'create', :conditions => { :method => :post }
  end

  map.with_options(:controller => 'carts') do |map|
    map.edit_cart '/cart', :action => 'edit',   :conditions => { :method => :get }
    map.cart      '/cart', :action => 'update', :conditions => { :method => :put }
  end

  map.with_options(:controller => 'items') do |map|
    map.items '/items',     :action => 'create',  :conditions => { :method => :post }
    map.item  '/items/:id', :action => 'destroy', :conditions => { :method => :delete }
  end

  map.with_options(:controller => 'orders') do |map|
    map.checkout '/checkout', :action => 'new', :conditions => { :method => :get }
  end

  map.with_options(:controller => 'payments') do |map|
    map.payments '/payments', :action => 'create', :conditions => { :method => :post }
  end
end

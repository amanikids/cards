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
    map.orders   '/orders',     :action => 'index',  :conditions => { :method => :get }
    map.checkout '/checkout',   :action => 'new',    :conditions => { :method => :get }
    map.connect  '/checkout',   :action => 'create', :conditions => { :method => :post }
    map.order    '/orders/:id', :action => 'show',   :conditions => { :method => :get }
  end

  map.with_options(:controller => 'payments') do |map|
    map.order_payments '/orders/:order_id/payment', :action => 'create', :conditions => { :method => :post }
    map.order_payment  '/orders/:order_id/payment', :action => 'update', :conditions => { :method => :put }
  end

  map.with_options(:controller => 'paypal_payments') do |map|
    map.order_paypal_payments '/orders/:order_id/paypal_payment', :action => 'create', :conditions => { :method => :post }
  end

  map.with_options(:controller => 'sessions') do |map|
    map.new_session '/sessions/new', :action => 'new',     :conditions => { :method => :get }
    map.sessions    '/sessions',     :action => 'create',  :conditions => { :method => :post }
    map.connect     '/sessions',     :action => 'destroy', :conditions => { :method => :delete }
  end
end

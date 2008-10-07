ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'cards'

  map.with_options(:controller => 'sessions') do |map|
    map.login   '/login', :action => 'new',    :conditions => { :method => :get }
    map.connect '/login', :action => 'create', :conditions => { :method => :post }
  end
end

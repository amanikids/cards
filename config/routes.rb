ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'cards'

  map.with_options(:controller => 'sessions') do |map|
    map.login   '/login',   :action => 'new',     :conditions => { :method => :get }
    map.connect '/login',   :action => 'create',  :conditions => { :method => :post }
    map.logout  '/logout',  :action => 'destroy', :conditions => { :method => :delete }
  end

  map.with_options(:controller => 'users') do |map|
    map.new_user '/signup', :action => 'new',     :conditions => { :method => :get }
    map.users    '/signup', :action => 'create',  :conditions => { :method => :post }
  end
end

Cards::Application.routes.draw do
  namespace :admin do
    get  '/sign-in'  => 'user_sessions#new',     :as => 'new_user_session'
    post '/sign-in'  => 'user_sessions#create',  :as => 'user_sessions'
    get  '/sign-out' => 'user_sessions#destroy', :as => 'destroy_user_session'

    resources :products

    root :to => redirect('/admin/products', :status => 302)
  end
end

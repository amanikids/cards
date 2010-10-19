Cards::Application.routes.draw do
  namespace :admin do
    controller :user_sessions do
      # TODO learn how to make these custom routes be named
      # 'new_admin_user_session' instead of 'admin_new_user_session'
      get  '/sign_in'  => :new,     :as => 'new_user_session'
      post '/sign_in'  => :create,  :as => 'user_sessions'
      get  '/sign_out' => :destroy, :as => 'destroy_user_session'
    end

    resources :products,
      :only => [:index, :new, :create]

    root :to => redirect('/admin/products', :status => 302)
  end

  resources :products,
    :only => :index

  resources :items,
    :only => :create

  namespace :checkout do
    controller :pay_pal do
      post '/paypal'          => :create, :as => 'paypal'
      get  '/paypal/callback' => :callback
      get  '/paypal/cancel'   => :cancel
    end
  end

  root :to => redirect('/products', :status => 302)
end

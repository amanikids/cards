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

  namespace :distributor do
    controller :user_sessions do
      # TODO learn how to make these custom routes be named
      # 'new_distributor_user_session' instead of 'distributor_new_user_session'
      get  '/sign_in'  => :new,     :as => 'new_user_session'
      post '/sign_in'  => :create,  :as => 'user_sessions'
      get  '/sign_out' => :destroy, :as => 'destroy_user_session'
    end

    resources :stores,
      :only => [:index, :show] do
      resources :orders,
        :only => [:update]
    end

    root :to => redirect('/distributor/stores', :status => 302)
  end

  scope '/:store_id', :as => 'store', :constraints => { :store_id => /[a-z][a-z]/ } do
    resources :items,
      :only => :create

    namespace :checkout do
      controller :paypal do
        post '/paypal'        => :create, :as => 'paypal'
        get  '/paypal/cancel' => :cancel
        get  '/paypal'        => :review
        put  '/paypal'        => :confirm
      end
    end

    resources :orders,
      :only => :show

    root :to => 'stores#show'
  end

  root :to => 'stores#index'
end

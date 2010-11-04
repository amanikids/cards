Cards::Application.routes.draw do
  # Admin routes ------------------------------------------------------
  namespace :admin do
    controller :user_sessions do
      get  '/sign_in'  => :new,     :as => 'new_user_session'
      post '/sign_in'  => :create,  :as => 'user_sessions'
      get  '/sign_out' => :destroy, :as => 'destroy_user_session'
    end

    resources :accounts,
      :only => %w(index)
    resources :paypal_accounts,
      :only => %w(new create)

    resources :stores,
      :only => [:index, :show] do
      resources :products,
        :only => [:new, :create]
    end

    root :to => redirect('/admin/accounts', :status => 302)
  end

  # Distributor routes ------------------------------------------------
  namespace :distributor do
    controller :user_sessions do
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

  # Donor routes ------------------------------------------------------
  scope '/:store_id', :as => 'store', :constraints => { :store_id => /[a-z][a-z]/ } do
    resources :items,
      :only => [:create, :destroy]

    namespace :checkout do
      controller :justgiving do
        post '/justgiving'         => :create, :as => 'justgiving'
        get  '/justgiving/address' => :address, :as => 'justgiving_address'
        put  '/justgiving/address' => :update_address
        get  '/justgiving/review'  => :review, :as => 'justgiving_review'
        put  '/justgiving'         => :donate
        get  '/justgiving'         => :complete
      end

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

Cards::Application.routes.draw do
  namespace :admin do
    get  '/sign-in' => 'user_sessions#new',    :as => 'new_user_session'
    post '/sign-in' => 'user_sessions#create', :as => 'user_sessions'
  end
end

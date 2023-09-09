Rails.application.routes.draw do  

  root 'users#index'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login'
  get '/logout', to: 'users#logout'
  get '/discover', to: 'movies#index'
  get '/dashboard', to: 'users#show'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  resources :movies, only: [:index, :show] do
    resources :viewing_party, only: [:new, :create]
  end
  
end

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  root 'users#index'
  get '/login', to: 'users#login_form'
  post '/login', to: 'users#login'
  get '/logout', to: 'users#logout'
  get '/discover', to: 'users#discover'
  get '/dashboard', to: 'users#show'

  get '/register', to: 'users#new'
  post '/register', to: 'users#create'

  resources :movies, only: [:index, :show] do
    resources :viewing_party, only: [:new, :create]
  end
end

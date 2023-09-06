Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  
  root 'users#index'
  get 'login', to: 'users#login_form'
  post 'login', to: 'users#login'

  get '/register', to: 'users#register', as: 'register_user'
  post '/register', to: 'users#create'

  resources :users, only: [:show] do
    get '/discover', to: 'users#discover'
    resources :movies, only: [:index, :show] do
      resources :viewing_party, only: [:new, :create]
    end
  end
end

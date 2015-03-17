Myflix::Application.routes.draw do
  
  root to: 'pages#front'
  get 'home', to: "videos#index"

  resources :videos, except: [:destroy] do
    collection do
      get :search, to: 'videos#search'
    end

    resources :reviews, only: [:create]
  end    

  resources :categories, only: [:show]

  resources :sessions, only: [:create]
  resources :users, only: [:create, :show]
  resources :queue_items, only: [:create, :destroy]

  get '/people', to: "relationships#index"
  resources :relationships, only: [:destroy, :create]

  post 'update_queue', to: 'queue_items#update_queue'

  resources :reset_passwords, only: [:new, :create, :edit, :update]
  
  get '/register', to: "users#new"

  get '/sign-in', to: "sessions#new"
  post 'sign-in', to: "sessions#create"
  get '/sign_out', to: "sessions#destroy"

  get '/my_queue', to: "queue_items#index"
  
  get 'ui(/:action)', controller: 'ui'
end

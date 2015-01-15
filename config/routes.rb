Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'

  root to: 'videos#index'

  resources :videos, except: [:destroy]

  resources :categories, only: [:show]
end

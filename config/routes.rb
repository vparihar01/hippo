Hippo::Application.routes.draw do
  resources :instances


  resources :cloud_providers do
    resources :instances
  end

  resources :users


  get "homes/index"
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions


resources :html do
  collection do
    get :sign_up
    get :dashboard_none
    end
  end
  root :to => 'homes#index'
end


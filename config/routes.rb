Hippo::Application.routes.draw do
  resources :cloud_providers


  resources :users


  get "homes/index"
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions

  resources :html do
    collection do
      get :sign_up
    end
  end
  root :to => 'homes#index'
end


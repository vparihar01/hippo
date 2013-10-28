Hippo::Application.routes.draw do
  resources :instances  do
    member do
      get :instance_status
    end
  end


  resources :cloud_providers do
    resources :instances do
      member do
        get :resize_server
        get :stop
        get :start
        get :reboot
      end
    end
  end



  get "homes/index"
  get 'logout', to: 'sessions#destroy', as: 'logout'

  resources :sessions


  resources :html do
    collection do
      get :sign_up
      get :dashboard_none
      get :dashboard
    end
  end
  root :to => 'homes#index'
end


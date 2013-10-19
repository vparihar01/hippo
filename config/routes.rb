Hippo::Application.routes.draw do
  resources :html do
  collection do
    get :sign_up
    end

  end
  # root :to => 'welcome#index'

end

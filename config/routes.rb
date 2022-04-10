Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users do
  end

  resources :tests, only: [] do
    collection do
      get :token
    end
  end

  # Defines the root path route ("/")
  # root "articles#index"
end

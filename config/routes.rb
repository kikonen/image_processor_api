Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users do
  end

  resources :uploads do
    resources :images do
    end
  end

  resources :images do
    resources :exif_values do
    end
  end

  resources :exif_values do
  end

  resources :tests, only: [] do
    collection do
      get :token
      get :system_token
    end
  end

  # Defines the root path route ("/")
  # root "articles#index"
end

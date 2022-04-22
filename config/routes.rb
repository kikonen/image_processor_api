# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :users do
    collection do
      scope :query do
        get "by_email"
      end
    end
  end

  resources :uploads do
    resources :images do
    end
  end

  resources :images do
    resources :exif_values do
    end

    member do
      post :fetch
    end
  end

  resources :exif_values do
  end

  resources :tests, only: [] do
    collection do
      get :users
      get :token
      get :system_token
      get :routes
    end
  end

  # Defines the root path route ("/")
  # root "articles#index"
end

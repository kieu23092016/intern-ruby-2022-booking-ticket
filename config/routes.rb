Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    post "/search", to: "static_pages#search"
    root "static_pages#home"

    resources :bookings, only: [:create, :destroy] do 
      resources :comments do 
        post "/", to: "comments#create"
      end
    end
    resource :bookings do 
      post "/date", to: "bookings#date_filter"
    end
    resources :bookings 
    resources :account_activations, only: [:edit]

    namespace :admin do
      root "static_pages#home"

      resources :movies do
        resources :show_times
      end

      resources :payments
      resources :users
      get "/add_movie", to: "movies#new"
    end

    resources :showtimes do
      member do
        post "/", to: "showtimes#create"
        delete "/", to: "showtimes#destroy"
      end
    end
    
    resources :payments do
      member do
        get "/save_payment", to: "payments#create"
      end
    end
  end
end

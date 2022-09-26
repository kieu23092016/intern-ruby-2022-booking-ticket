Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    root "static_pages#home"

    resources :bookings

    namespace :admin do
      root "static_pages#home"
      resources :movies
      resources :categories
      resources :users
      get "/add_movie", to: "movies#new"
    end
    resources :tickets do
      member do
        post "/", to: "tickets#create"
        delete "/", to: "tickets#destroy"
      end
    end
    resources :payment
  end
end

Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    get "/home" ,to: "static_pages#home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    root "static_pages#home"

    resources :bookings
  end
end

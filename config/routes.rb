Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    devise_for :users
    get "/search", to: "static_pages#search"
    root "static_pages#home"
    
    resources :bookings, only: [:create, :destroy] do 
      resources :comments do 
        post "/", to: "comments#create"
      end
    end
    resources :search_showtime
    resources :bookings 
    resources :account_activations, only: [:edit]

    

    resources :show_times do
      member do
        post "/", to: "show_times#create"
        delete "/", to: "show_times#destroy"
      end
    end
    
    resources :payments do
      member do
        get "/save_payment", to: "payments#create"
      end
    end
  end
  constraints subdomain: 'api' do
    scope module: 'api' do
      # namespace :v1 do
      resources :bookings, only: [:new, :show] 
      # end
      post "/auth/login", to: "authentication#sign_up"
      namespace :admin do
        root "static_pages#home"
  
        resources :movies do
          resources :show_times
        end
  
        resources :payments
        resources :users
        get "/add_movie", to: "movies#new"
      end
    end
  end
end

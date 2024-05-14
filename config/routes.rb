Rails.application.routes.draw do
  devise_for :users
  namespace :api do
    namespace :v1 do
      # System Statistics
      resources :system_statistics, only: [] do
        collection do
          get 'total_rides_count'
          get 'daily_rides_count'
          get 'total_drivers_count'
          get 'highest_rides_users'
          get 'highest_rides_drivers'
          get 'highest_rides_users_by_month/:month/:year', to: 'system_statistics#highest_rides_users_by_month'
          get 'highest_rides_drivers_by_month/:month/:year',  to: 'system_statistics#highest_rides_drivers_by_month'
          get 'calculate_usage_percentage'
          get 'rides_for_driver', to: 'system_statistics#rides_for_driver'
        end
      end

      # Devise Authentication
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"
      end

      # Users
      resources :users, only: [:index, :update, :destroy] do
        collection do
          get 'me/rides', to: 'users#view_rides'
          get 'rides_for_date', to: 'users#rides_for_date'
        end
      end

      # Drivers
      resources :drivers, only: [:index, :show, :create, :update, :destroy] do
        member do
          put 'update', to: 'drivers#update'
          get 'rides_for_driver'
        end
      end

      # Driver Ride Ratings
      resources :driver_ride_ratings, only: [:create, :index, :show] do 
        member do
          get 'average_rating_for_driver'
        end
      end

      # User Ratings
      resources :user_ratings, only: [] do
        collection do
          get 'average_rating_by_user'
        end
      end
      
      
      # Vehicles
      resources :vehicles, only: [:index, :show, :new, :create, :edit, :update, :destroy]

      # Rides
      resources :rides do
        member do
          patch 'swap_vehicle'
          post 'add_user', to: 'rides#add_user_to_ride'
          delete 'remove_user', to: 'rides#remove_user'
          post 'replace_user'
          get 'rides_for_user'
          get 'rides_for_date'
          get 'rides_for_time_range'
          post 'complete_ride'
        end
      end
    end
  end
   # Health Check
  get "up" => "rails/health#show", as: :rails_health_check
end

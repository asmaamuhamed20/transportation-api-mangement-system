Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'

  devise_for :users, controllers: {
    registrations: 'api/v1/registrations',
    sessions: 'api/v1/sessions'
  }
  
  # Devise Authentication
  devise_scope :user do
    post "sign_up", to: "api/v1/registrations#create"
    post "sign_in", to: "api/v1/sessions#create"
  end
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
      # devise_scope :user do
      #   post "sign_up", to: "registrations#create"
      #   post "sign_in", to: "sessions#create"
      # end

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
      resources :user_ratings, only: [:create, :show] do
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
        #  post 'apply_coupon'
        end
      end

      # Invoices
      resources :invoices, only: [] do
        collection do
          get 'list_all_invoices'
          get 'user_invoices_history/:user_id', to: 'invoices#user_invoices_history'
        end
      end

      # Driver Peyment
      resources :driver_payments, only: [:create] do
        collection do
          get 'driver_payments_history/:driver_id', to: 'driver_payments#driver_payments_history'
        end
      end


      # Coupons 
      resources :coupons, only: [:index, :show, :create, :update, :destroy] do
        post 'apply/:ride_id', to: 'coupons#apply', on: :collection
      end
      
    end
  end
   # Health Check
  get "up" => "rails/health#show", as: :rails_health_check
end

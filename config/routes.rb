Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'system_statistics/total_rides_count'
      get 'system_statistics/daily_rides_count'
      get 'system_statistics/total_drivers_count'
      get 'system_statistics/highest_rides_users'
      get 'system_statistics/highest_rides_drivers'
      get 'system_statistics/usage_percentage'
      get 'system_statistics/rides_for_driver', to: 'system_statistics#rides_for_driver'
      get 'user_ratings/average_rating_by_user', to: 'user_ratings#average_rating_by_user'

      resources :users, only: [] do
        collection do
        get 'me/rides', to: 'users#view_rides'
        get 'rides_for_date', to: 'users#rides_for_date'
      end
    end

    resources :drivers do
      member do
        put 'update', to: 'drivers#update'
      end
    end
  end
end

    devise_for :users
    namespace :api, defaults: {format: :json} do
      namespace :v1 do 
        devise_scope :user do
          post "sign_up", to: "registrations#create"
          post "sign_in", to: "sessions#create"
        end

        resources :vehicles, only: [:index, :show, :new, :create, :edit, :update, :destroy]

        resources :rides do

          resources :driver_ride_ratings, only: [:create], controller: 'driver_ride_ratings'

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

        resources :drivers, only: [:index, :show, :create, :update, :destroy] do
          member do
            get 'average_rating'
            get 'rides_for_driver'
          end
        end

        resources :driver_ride_ratings, only: [:show] do
          collection do
            get 'average_rating_for_driver'
          end
        end

        resources :users, only: [:index, :create, :update, :destroy]
      end
    end


  get "up" => "rails/health#show", as: :rails_health_check
end

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  devise_for :users
    namespace :api, defaults: {format: :json} do
      namespace :v1 do 
          devise_scope :user do
            post "sign_up", to: "registrations#create"
            post "sign_in", to: "sessions#create"
          end
      resources :vehicles, only: [:index, :show, :new, :create, :edit, :update, :destroy]
      resources :rides, only: [:index, :show, :new, :create, :edit, :update, :destroy]
      resources :rides do
        member do
          patch 'swap_vehicle'
        end
      end
      resources :users, only: [:create, :show, :update, :destroy]
      resources :users, only: [:destroy]
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

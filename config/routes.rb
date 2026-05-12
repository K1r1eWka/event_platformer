Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "auth/login", to: "sessions#create"
      resources :events do
        resources :zones, only: [ :index, :show, :create ] do
          resources :tickets, only: [ :create ]
        end
        resources :tickets, only: [ :index ]
      end

      resources :tickets, only: [ :update ]
    end
  end
end

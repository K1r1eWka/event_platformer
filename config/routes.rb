require "sidekiq/web"

Rails.application.routes.draw do
  Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_sidekiq_session"


  mount Sidekiq::Web => "/sidekiq"
  namespace :api do
    namespace :v1 do
      scope "/auth" do
        post "/login", to: "sessions#create"
        post "/register", to: "users#create"
      end
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

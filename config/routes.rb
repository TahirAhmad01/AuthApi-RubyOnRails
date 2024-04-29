Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    scope :v1 do
      devise_for :users, controllers: {
        sessions: "sessions",
        registrations: "registrations",
      }
    end
  end

  namespace :api, defaults: {format: :json } do
    namespace :v1 do
      resources :companies
      root to: "home#index", as: "api_home"
    end
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end

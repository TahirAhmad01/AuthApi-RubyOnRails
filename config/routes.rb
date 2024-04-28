Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
  }

  namespace :api do
    namespace :v1 do
      resources :companies
      root to: "home#index", as: "api_home"
    end
  end

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check
end

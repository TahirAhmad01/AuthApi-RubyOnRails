Rails.application.routes.draw do
  devise_for :users, scope: :controller

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_scope :user do
        post "sign_up", to: "registrations#create"
        post "sign_in", to: "sessions#create"
        post "sign_out", to: "sessions#destroy"
        # post "update/:id", to: "users#update"  # Add if needed
      end
      resources :companies
      root to: "home#index", as: "api_home"
    end
  end

  # Health check route
  # get "up" => "rails/health#show", as: :rails_health_check
end

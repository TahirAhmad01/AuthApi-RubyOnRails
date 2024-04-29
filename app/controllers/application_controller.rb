class ApplicationController < ActionController::API
  respond_to :json
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def configure_permitted_parameters
    devise_parameter_sanitizer
      .permit(:sign_up) do |u|
      u.permit(
        :email,
        :password,
        :password_confirmation,
        :role,
        :password_confirmation
      )
    end

    devise_parameter_sanitizer
      .permit(:account_update) do |u|
      u.permit(
        :email,
        :password,
        :password_confirmation,
        :current_password,
        :role,
        :password_confirmation
      )
    end
  end
end


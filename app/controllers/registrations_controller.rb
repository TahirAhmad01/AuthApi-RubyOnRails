class RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    if current_user
      render json: {
        error: "You are already logged in",
        data: current_user,
        status: 401
      }
    else
      super
    end
  end

  private

  def respond_with (resource, options = {})
    if resource.persisted?
      render json: {
        code: 200, message: "User registration was successfully registered", data: resource
      }, status: :ok
    else
      errors_array = resource.errors.messages.map do |attribute, messages|
        { name: attribute, errors: messages }
      end
      render json: {
        error: "User registration failed", error_messages: errors_array
      }, status: :unprocessable_entity
    end
  end
end

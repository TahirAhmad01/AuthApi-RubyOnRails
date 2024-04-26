# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  private

  def respond_with (resource, options = {})
    if current_user
      render json: { error: "User Already Signed In. Please log out before proceeding with registration.",
                     data: current_user,
                     status: 200 }, status: :ok
    else
      if resource.persisted?
        render json: {
          code: 200, message: "User registration was successfully registered", data: resource
        }, status: :ok
      else
        render json: {
          message: "User registration failed", data: resource.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

  end
end

# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        message: "User Signed in Successfully",
        data: current_user
      }, status: :ok
    else
      render json: {
        message: resource.errors.full_messages.to_sentence,
        data: resource
      }, status: :unprocessable_entity
    end
  end

  def respond_to_on_destroy
    jwt_payload = JWT.decode(request.headers["Authorization"].split(" ")[1], Rails.application.credentials.fetch(:secret_key_base)).first
    puts "Payload: #{jwt_payload}"
    current_user = User.find(jwt_payload["sub"])
    if current_user
      render json: {
        status: 200,
        message: "User Signed out Successfully"
      }, status: :ok
    else
      render json: {
        status: 401,
        message: "User has no active sessions"
      }, status: :unauthorized
    end
    end
end

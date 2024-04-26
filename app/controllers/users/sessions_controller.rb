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
    if request.headers["Authorization"].present?
      token = request.headers["Authorization"].split(" ").last
      begin
        jwt_payload = JWT.decode(token, Rails.application.credentials.secret_key_base).first
        current_user = User.find(jwt_payload["sub"])
        render json: {
          status: 200,
          message: "User Signed out Successfully"
        }, status: :ok
      rescue JWT::DecodeError => e
        render json: {
          status: 401,
          message: "Invalid JWT token: #{e.message}"
        }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: 404,
          message: "User not found"
        }, status: :not_found
      end
    else
      render json: {
        status: 401,
        message: "Authorization header missing"
      }, status: :unauthorized
    end
  end
end

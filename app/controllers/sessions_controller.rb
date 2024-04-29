# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    if resource.persisted?
      render json: {
        code: 200,
        message: "User signed in successfully",
        data: current_user
      }, status: :ok
    else
      errors_array = resource.errors.messages.map do |attribute, messages|
        { name: attribute, errors: messages }
      end

      render json: {
        error: resource.errors.full_messages.to_sentence,
        error_messages: errors_array
      }, status: :unprocessable_entity
    end
  end

  def respond_to_on_destroy
    if request.headers["Authorization"].present?
      token = request.headers["Authorization"].split(" ").last
      begin
        jwt_payload = JWT.decode(token, Rails.application.credentials.fetch(:secret_key_base)).first
        current_user = User.find(jwt_payload["sub"])
        render json: {
          status: 200,
          message: "User Signed out Successfully",
          data: current_user
        }, status: :ok
      rescue JWT::DecodeError => e
        render json: {
          status: 401,
          error: "Invalid JWT token: #{e.message}"
        }, status: :unauthorized
      rescue ActiveRecord::RecordNotFound => e
        render json: {
          status: 404,
          error: "User not found"
        }, status: :not_found
      end
    else
      render json: {
        status: 401,
        error: "Authorization header missing"
      }, status: :unauthorized
    end
  end
end

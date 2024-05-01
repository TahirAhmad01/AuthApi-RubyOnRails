# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  respond_to :json

  include Jwt::Refresher

  def create
    super do |resource|
      access_token, refresh_token = Jwt::Issuer.call(resource)
      response.headers['access-token'] = access_token
      response.headers['refresh-token'] = refresh_token.crypted_token # Adjusted to use crypted_token
    end
  end

  def refresh
    refresh_token = request.headers['refresh-token']
    access_token, new_refresh_token = refresh!(refresh_token: refresh_token, decoded_token: nil, user: current_user)
    response.headers['access-token'] = access_token
    response.headers['refresh-token'] = new_refresh_token.token
    head :ok
  end


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
        jwt_payload = JWT.decode(token, ENV['JWT_SECRET_KEY']).first
        current_user = User.find(jwt_payload["sub"])

        # Sign out logic
        sign_out(current_user) # Assuming you're using Devise for authentication

        # Clear session
        reset_session
        if jwt_payload
          render json: {
            code: 200,
            message: "User signed out successfully"
          }, status: :ok
        end


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

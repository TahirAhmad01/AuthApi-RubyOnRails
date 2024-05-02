# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  respond_to :json

  def create
    super do |user|
      if user.persisted?
        token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
        render json: { message: "User signed in successfully", user: user, token: token }, status: :ok
        return
      else
        render json: { message: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end

  def refresh
    if current_user
      token = Warden::JWTAuth::UserEncoder.new.call(current_user, :user, nil)
      render json: { user: current_user, token: token }, status: :ok
    end
  end

  def destroy
    if request.headers["Authorization"].present?
      token = request.headers["Authorization"].split(" ").last
      begin
        jwt_payload = JWT.decode(token, ENV['JWT_SECRET_KEY']).first
        # current_user = User.find(jwt_payload["sub"])
        if jwt_payload
          super
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

  private

  def respond_to_on_destroy
  end
end

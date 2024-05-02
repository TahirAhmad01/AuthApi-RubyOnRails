class ApiController < ApplicationController
  before_action :authenticate_user!
  # before_action :check_valid_token

  load_and_authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    render json: { warning: exception, status: :authorization_failed }, status: :forbidden
  end

  private

  # def check_valid_token
  #   if request.headers[:auth_token].present?
  #     token = request.headers[:auth_token].split(" ").last
  #     begin
  #       jwt_payload = JWT.decode(token, ENV['JWT_SECRET_KEY']).first
  #       current_user = User.find(jwt_payload["sub"])
  #
  #       if current_user.nil?
  #         render json: {
  #           status: 401,
  #           error: "User not found"
  #         }, status: :not_found
  #         return
  #       end
  #
  #     rescue JWT::DecodeError => e
  #       render json: {
  #         status: 401,
  #         error: "Invalid JWT token: #{e.message}"
  #       }, status: :unauthorized
  #     rescue ActiveRecord::RecordNotFound => e
  #       render json: {
  #         status: 404,
  #         error: "User not found"
  #       }, status: :not_found
  #     end
  #   else
  #     render json: {
  #       status: 401,
  #       error: "Authorization header missing"
  #     }, status: :unauthorized
  #   end
  # end
end
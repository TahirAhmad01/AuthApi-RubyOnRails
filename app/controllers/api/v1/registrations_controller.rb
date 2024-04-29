module Api
  module V1
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

      #   private
      #
      #   def respond_with(resource, _opts = {})
      #     if resource.persisted?
      #       render json: {
      #         code: 200,
      #         message: "User registration was successful",
      #         data: resource
      #       }, status: :ok
      #     else
      #       errors_array = resource.errors.messages.map do |attribute, messages|
      #         { attribute: attribute, errors: messages }
      #       end
      #       render json: {
      #         message: "User registration failed",
      #         errors: errors_array
      #       }, status: :unprocessable_entity
      #     end
      #   end
      # end
    end
  end
end

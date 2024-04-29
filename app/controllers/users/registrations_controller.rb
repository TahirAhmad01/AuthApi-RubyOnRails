class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    if current_user
      render json: {
        error: "You are already logged in",
        data: current_user,
        status: 401
      }
    else
      super do |resource|
        if resource.persisted?
          return render_registration_success(resource)
        else
          return render_registration_failure(resource)
        end
      end
    end
  end

  private

  def render_registration_success(resource)
    render json: {
      code: 200,
      message: "User registration was successful",
      data: resource
    }, status: :ok
  end

  def render_registration_failure(resource)
    errors_array = resource.errors.messages.map do |attribute, messages|
      { name: attribute, errors: messages.map { |error| "#{attribute} #{error}" } }
    end

    render json: {
      message: "User registration failed",
      errors: errors_array
    }, status: :unprocessable_entity
  end

  def after_sign_up_path_for(resource)
    user_path(resource)
  end
end

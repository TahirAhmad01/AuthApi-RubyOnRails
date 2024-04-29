class Api::V1::HomeController < ApiController

  def index
    if user_signed_in?
      render json: {
        code: 200,
        data: current_user
      }
    else
      render json: {
        code: 200,
        data: {
          message: "You are not logged in"
        }
      }
    end
  end

  def about
  end

  def contact
  end
end

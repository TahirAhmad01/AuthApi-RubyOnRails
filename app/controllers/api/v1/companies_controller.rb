class Api::V1::CompaniesController < ApiController
  before_action :set_company, only: [:show, :update, :destroy]

  def index
    @companies = Company.accessible_by(current_ability)
    # @companies = current_user.companies
    render json: @companies, status: :ok
  end

  def show
    render json: @company, status: :ok
  end

  def create
    @company = Company.new(company_params)
    # @company = current_user.companies.new(company_params)
    if @company.save
      render json: { message: "Company created successfully", data: @company, status: 200 }, status: :created
    else
      errors_array = @company.errors.messages.map do |attribute, messages|
        { name: attribute, errors: messages }
      end
      render json: { errors: errors_array, status: :unprocessable_entity }
    end
  end

  def update
    if @company.update(company_params)
      render json: { message: "Company updated successfully", data: @company, status:
        200 }, status: :ok
    else
      render json: { error: "Company update failed", error_messages: @company.errors, status: 422 }, status: :unprocessable_entity
    end
  end

  def destroy
    if @company
      if @company.destroy
        render json: { message: "Company deleted successfully", status: 200 }, status: :ok
      else
        render json: { error: "something went wrong", status: "failed" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Company not found", status: "failed" }, status: :not_found
    end
  end

  private

  def set_company
    puts "Current User: #{current_user.inspect}"
    @company = Company.find(params[:id])
    # @company = current_user.companies.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Company not found" }, status: :not_found
  end

  def company_params
    params.require(:company).permit(:name, :established_year, :address, :user_id)
  end
end

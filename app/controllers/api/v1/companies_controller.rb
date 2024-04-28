class Api::V1::CompaniesController < ApiController
  before_action :set_company, only: [:show]

  def index
    @companies = current_user.companies
    render json: @companies, status: :ok
  end

  def show


    render json: @company, status: :ok
  end

  def create
    @company = current_user.companies.new(company_params)
    if @company.save
      render json: @company, status: :created
    else
      render json: @company.errors, status: :unprocessable_entity
    end
  end

  private

  def set_company
    puts "Current User: #{current_user.inspect}"
    @company = current_user.companies.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Company not found" }, status: :not_found
  end

  def company_params
    params.require(:company).permit(:name, :established_year, :address, :user_id)
  end
end

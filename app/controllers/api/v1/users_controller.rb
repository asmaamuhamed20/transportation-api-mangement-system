class Api::V1::UsersController < ApplicationController
  before_action :authorize_admin, only: [:destroy, :update]

 

  # swagger_api :index do
  #   summary 'Fetches all users'
  #   param :query, :page, :integer, :optional, 'Page number'
  #   param :query, :per_page, :integer, :optional, 'Number of items per page'
  #   response :success, 'List of users fetched successfully'
  #   response :unprocessable_entity, 'Invalid page or per_page parameter'
  # end
  # GET: /api/v1/users
  def index
    render json: User.all, status: :ok
  end

  def show
    render json: user, status: :ok
  end

  def create  
    result = User.create_user(user_params)
    if result[:status] == :created
      render json: result[:user], status: :created
    else
      render_errors(result[:errors])
    end
  end

  # PUT: /api/v1/users/user_id
  def update
    result = user.update_user(user_params)
    if result[:status] == :ok
      render json: result[:user], status: :ok
    else
      render_errors(result[:errors])
    end
  end

  # DELETE: /api/v1/users/user_id
  def destroy
    result = user.destroy_user
    if result[:status] == :ok
      render_success(result[:message])
    else
      render_error(:unprocessable_entity, result[:message])
    end
  end
  
  # GET: /api/v1/users/me/rides
  def view_rides
    render_rides(current_user.rides.includes(:driver, :vehicle).order(start_time: :desc))
  end
  
  # GET: /api/v1/users/rides_for_date?date=
  def rides_for_date
    rides = User.rides_for_date(current_user, params[:date])
    render_rides(rides)
  end

  private

  def user
    @user ||= User.find(params[:id])
  end

  def authorize_admin
    render_unauthorized unless current_user&.admin?
  end
  
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
  end

  def render_rides(rides)
    if rides.present?
      render json: rides, status: :ok
    else
      render_error(:not_found, 'No rides found')
    end
  end

  def render_success(message)
    render json: { message: message, is_success: true }, status: :ok
  end

  def render_error(status, message)
    render json: { error: message }, status: status 
  end

  def render_errors(errors)
    render json: { errors: errors }, status: :unprocessable_entity
  end

  def render_unauthorized
    render json: { error: "Only admin users are authorized to perform this action" }, status: :unauthorized
  end

  def render_not_found(message)
    render json: { error: message }, status: :not_found
  end
end

class Api::V1::UsersController < ApplicationController
  before_action :authorize_admin, only: [:destroy, :update]

  # GET: /api/v1/users
  def index
    render json: users, status: :ok
  end

  def show
    render json: user, status: :ok
  end

  def create  
    if save_user
      render json: user, status: :created
    else
      render_errors(user.errors.full_messages)
    end
  end

  # PUT: /api/v1/users/user_id
  def update
    if user.update(user_params)
      render json: user, status: :ok
    else
      render_errors(user.errors.full_messages)
    end
  end

  # DELETE: /api/v1/users/user_id
  def destroy
    if destroy_user_resources(user)
      render_success("User and associated resources deleted successfully")
    else
      render_error(:unprocessable_entity, "Failed to delete user and associated resources")
    end
  end
  
  # GET: /api/v1/users/me/rides
  def view_rides
    render_rides(current_user.rides.includes(:driver, :vehicle).order(start_time: :desc))
  end
  
  # GET: /api/v1/users/rides_for_date?date=
  def rides_for_date
    render_rides(rides_for_current_user)
  end

  private

  def users
    User.all
  end

  def user
    @user ||= User.find(params[:id])
  end

  def authorize_admin
    render_unauthorized unless current_user&.admin?
  end

  def save_user
    user = User.new(user_params)
    user.save
  end 
  
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
  end

  def destroy_user_resources(user)
    user.rides.destroy_all && user.driver_ride_ratings.destroy_all && user.destroy
  end

  def render_rides(rides)
    if rides.present?
      render json: rides, status: :ok
    else
      render_error(:not_found, 'No rides found')
    end
  end

  def rides_for_current_user
    if current_user.admin?
      Ride.where('DATE(start_time) = ?', params[:date]).includes(:driver, :vehicle).order(start_time: :desc)
    else
      current_user.rides.where('DATE(start_time) = ?', params[:date]).includes(:driver, :vehicle).order(start_time: :desc)
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
end

class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:rides_for_date, :view_rides]
  before_action :authorize_admin, only: [:destroy]

  #access all: [:show, :index], user: { except: [:destroy, :new, :create, :update, :edit] }, admin: :all

  def index
    users = User.all
    render json: users, status: :ok
  end

  def show
    user = User.find(params[:id])
    render json: user, status: :ok
  end

  def create
    user = User.new(user_params)
  
    if user.save
      render json: user, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    user = User.find(params[:id])

    if user.update(user_params)
      render json: user, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    user = User.find(params[:id])

    if user.destroy
      render json: { message: "User deleted successfully", is_success: true }, status: :ok
    else
      render json: { message: "Failed to delete user", is_success: false }, status: :unprocessable_entity
    end
  end
  
  def view_rides
    user = current_user
    @rides = user.rides.includes(:driver, :vehicle).order(start_time: :desc)
    if @rides.present?
      render json: @rides, status: :ok
    else
      render_error(:not_found, 'No rides found for the current user')
    end
  end

  def rides_for_date
    user = current_user
    date = params[:date]
    @rides = user.rides.where('DATE(start_time) = ?', date)

    if @rides.present?
      render json: @rides
    else
      render_error(:not_found, 'No rides found for specified date')
    end
  end

  private

  def authorize_admin
    authorize User, :admin?
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def render_error(status, message)
    render json: { error: message }, status: status 
  end
end

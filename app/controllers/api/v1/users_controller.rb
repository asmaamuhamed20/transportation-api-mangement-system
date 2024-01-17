class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  def show
    render json: current_user
  end

  def create
    @user = User.new(user_params)
  
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if current_user.update(user_params)
      render json: {
        messages: "Profile Updated Successfully",
        is_success: true,
        data: { user: current_user.slice(:id, :email, :created_at, :updated_at, :username) }
      }, status: :ok
    else
      render json: {
        messages: "Profile Update Failed",
        is_success: false,
        data: {}
      }, status: :unprocessable_entity
    end
  end
  
  
  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end
end
  
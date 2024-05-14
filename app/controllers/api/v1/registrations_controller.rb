class Api::V1::RegistrationsController < Devise::RegistrationsController
  before_action :ensure_params_exist, only: :create
  
  # POST /api/v1/sign_up
  def create
    user = User.new user_params
    if user.save
      render_success(user)
    else
      render_error("Sign Up Failed", :unprocessable_entity)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username)
  end  

  def ensure_params_exist
    return if params[:user].present?
    render_error("Missing Params", :bad_request)
  end

  def render_success(user)
    render json: {
      messages: "Sign Up Successfully",
      is_success: true,
      data: { user: user.slice(:id, :email, :created_at, :updated_at, :username) }
    }, status: :ok
  end

  def render_error(message, status)
    render json: {
      messages: message,
      is_success: false,
      data: {}
    }, status: status
  end
end
class Api::V1::SessionsController < Devise::SessionsController
  before_action :authenticate_user, only: :create
  respond_to :json

   # POST /api/v1/sign_in
  def create
    if @user.valid_password?(user_params[:password])
      sign_in  @user
      render_sign_in_success
    else
      render_sign_in_failure
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password)
  end  

  def authenticate_user
    @user = User.find_for_database_authentication(email: user_params[:email])
    return if @user
  
    render_unauthorized("Cannot find user. Please register.")
  end
  
  def render_unauthorized(message)
    render json: { messages: message, is_success: false, data: {} }, status: :unauthorized
  end

  def render_sign_in_success
    token = JsonWebToken.encode(user_id: @user.id)
    render json: { messages: "Signed In Successfully", is_success: true, data: { user: @user, token: token } }, status: :ok
  end

  def render_sign_in_failure
    render json: { messages: "Signed In Failed - Unauthorized", is_success: false, data: {} }, status: :unauthorized
  end
end
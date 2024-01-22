class Api::V1::SessionsController < Devise::SessionsController
  before_action :sign_in_params, only: :create
  before_action :load_user, only: :create
  respond_to :json

  # sign in
  def create
    if @user.valid_password?(sign_in_params[:password])
      sign_in  @user

      token = JsonWebToken.encode(user_id: @user.id)

      render json: {
        messages: "Signed In Successfully",
        is_success: true,
        data: {user: @user, token: token}
      }, status: :ok
    else
      render json: {
        messages: "Signed In Failed - Unauthorized",
        is_success: false,
        data: {}
      }, status: :unauthorized
    end
  end

  private
  def sign_in_params
    params.require(:user).permit(:email, :password)
  end  

  def load_user
    @user = User.find_for_database_authentication(email: sign_in_params[:email])
    if @user
      return @user
    else
      render json: {
        messages: "Cannot get User, please register new user",
        is_success: false,
        data: {}
      }, status: 500 
    end
  end
end
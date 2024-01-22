class ApplicationController < ActionController::API
    before_action :authenticate_request!

    private
  
    def authenticate_request!
      unless user_id_in_token?
        render json: { error: 'Not authorized' }, status: :unauthorized
        return
      end
  
      @current_user = User.find(auth_token['user_id'])
    rescue JWT::VerificationError, JWT::DecodeError
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  
    def http_token
      @http_token ||= if request.headers['Authorization'].present?
        request.headers['Authorization'].split(' ').last
      end
    end
  
    def auth_token
      @auth_token ||= JsonWebToken.decode(http_token)
    end
  
    def user_id_in_token?
      http_token && auth_token && auth_token['user_id'].to_i
    end
end

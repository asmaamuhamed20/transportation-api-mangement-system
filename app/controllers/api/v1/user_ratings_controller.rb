class Api::V1::UserRatingsController < ApplicationController
    before_action :set_ride, only: [:create]
    
    # POST: /api/v1/user_ratings
    def create
        result = UserRating.create_user_rating(@ride, user_rating_params, current_user)
        if result[:success]
          render_json_success("User rating created successfully", result[:user_rating])
        else
          render_error(:unprocessable_entity, result[:error])
        end
    end

    # GET: /api/v1/user_ratings/user_id
    def show
        @user_rating = UserRating.find(params[:id])
        render json: @user_rating
    end

    # GET: /api/v1/user_ratings/average_rating_by_user?user_id=
    def average_rating_by_user 
        result = UserRating.average_rating_by_user(params[:user_id])
        if result[:success]
          render_json_success({ user_id: params[:user_id], average_rating: result[:average_rating] })
        else
          render_error(:not_found, result[:error])
        end
    end


    private

    def set_ride
        ride_id = params.dig(:user_rating, :ride_id)
        @ride = Ride.find_by(id: ride_id)
 
        unless @ride && @ride.can_be_rated_by?(current_user)
            render_error(:unprocessable_entity, @ride ? "Current user is not allowed to rate this ride" : "Invalid ride ID")
        end
    end
          

    def user_rating_params
        params.require(:user_rating).permit(:comment, :rating, :ride_id)
    end

    def render_json_success(message, data = {})
        render json: { success: true, message: message, data: data }, status: :ok
    end

    def render_error(status, messages)
        render json: { error: messages }, status: status
    end
end

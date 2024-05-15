class Api::V1::UserRatingsController < ApplicationController
    before_action :set_ride, only: [:create]
    
    # POST: /api/v1/user_ratings
    def create
        build_user_rating
    
        if @user_rating.save
            render_json_success("User rating created successfully", @user_rating)
        else
            render_error(:unprocessable_entity, @user_rating.errors.full_messages)
        end
    end

    # GET: /api/v1/user_ratings/user_id
    def show
        @user_rating = UserRating.find(params[:id])
        render json: @user_rating
    end

    # GET: /api/v1/user_ratings/average_rating_by_user?user_id=
    def average_rating_by_user 
        user_id = params[:user_id]
        user_ratings = UserRating.where(user_id: user_id)
        if user_ratings.present?
            average_rating = calculate_average_rating(user_ratings)
            render_json_success({ user_id: user_id, average_rating: average_rating })
        else     
            render_error(:not_found, 'No ratings available for the user') 
        end
    end


    private

    def set_ride
        ride_id = params.dig(:user_rating, :ride_id)
        @ride = Ride.find_by(id: ride_id)
      
        return if @ride && @ride.can_be_rated_by?(current_user)
      
        render_error(:unprocessable_entity, @ride ? "Current user is not allowed to rate this ride" : "Invalid ride ID")
    end
          

    def user_rating_params
        params.require(:user_rating).permit(:comment, :rating, :ride_id)
    end

    def build_user_rating
        @user_rating = @ride.user_ratings.build(user_rating_params.merge(user_id: current_user.id))
    end
    
    def calculate_average_rating(user_ratings)
        total_ratings = user_ratings.count
        sum_of_ratings = user_ratings.sum(:rating)
        average_rating = sum_of_ratings.to_f / total_ratings
    end

    def render_json_success(message, data = {})
        render json: { success: true, message: message, data: data }, status: :ok
    end

    def render_error(status, messages)
        render json: { error: messages }, status: status
    end
end

class Api::V1::UserRatingsController < ApplicationController
    before_action :set_ride, only: [:create, :show]
    
    def create
        @user_rating = @ride.user_ratings.build(user_rating_params.merge(user: current_user))

        if  @user_rating.save
            render_json_success( @user_rating)
        else
            render_error(:unprocessable_entity,  @user_rating.errors.full_messages)
        end
    end

    def show
        @user_rating = @ride.user_ratings.find(params[:id])
        render json: @user_rating
    end

    def average_rating_by_user  #Average rating provided by a specific user
        user_id = params[:user_id]
        user_ratings = UserRating.where(user_id: user_id)
        if user_ratings.present?
            total_ratings = user_ratings.count
            sum_of_ratings = user_ratings.sum(:rating)
            average_rating = sum_of_ratings.to_f / total_ratings

            render_json_success({ user_id: user_id, average_rating: average_rating })
        else     
            render_error(:not_found, 'No ratings available for the user') 
        end
    end


    private

    def set_ride
        @ride = Ride.find(params[:ride_id])
    end

    def user_rating_params
        params.require(:user_rating).permit(:comment, :rating)
    end

    def render_error(status, messages)
        render json: { error: messages }, status: status
    end
        
    def render_json_success(message, data = {})
        render json: { success: true, message: message, data: data }, status: :ok
    end
end

class Api::V1::RideReviewsController < ApplicationController
    before_action :set_ride, only: [:create, :show]
    
    def create
        @ride_review = @ride.ride_reviews.build(ride_review_params.merge(user: @ride.user))

        if @ride_review.save
            render_json_success( @ride_review)
        else
            render_error(:unprocessable_entity, @ride_review.errors.full_messages)
        end
    end

    def show
        @ride_review = @ride.ride_reviews.find(params[:id])
        render json: @ride_review
    end

    private

    def set_ride
        @ride = Ride.find(params[:ride_id])
    end

    def ride_review_params
        params.require(:ride_review).permit(:user_id, :comment, :rating)
    end

    def render_error(status, messages)
        render json: { error: messages }, status: status
    end
        
    def render_json_success(message, data = {})
        render json: { success: true, message: message, data: data }, status: :ok
    end
end

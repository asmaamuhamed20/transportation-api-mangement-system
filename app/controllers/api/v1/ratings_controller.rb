class Api::V1::RatingsController < ApplicationController
    before_action :set_ride
    
    def create
        # driver reviews a user
        @rating = @ride.ratings.build(rating_params.merge(user: @ride.user, driver: @ride.driver))
        
        if @rating.save
        render json: @rating, status: :created
        else
        render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        render json: @rating
    end

    def index
        @ratings = Rating.where(ride_id: params[:ride_id])
        render json: @ratings
    end

    def update
        
    end

    def destroy
        
    end

    private


    def set_ride
        @ride = Ride.find(params[:ride_id])
    end

    def rating_params
        params.require(:rating).permit(:ride_id, :user_id, :driver_id, :rating_value, :comment)
    end
end

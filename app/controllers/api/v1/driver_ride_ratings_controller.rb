class Api::V1::DriverRideRatingsController < ApplicationController
    before_action :set_ride
    before_action :authorize_admin, only: [:create] 

    
    def create
        # driver reviews a user
        @rating = @ride.driver_ride_ratings.build(rating_params.merge(user: @ride.user, driver: @ride.driver))
        
        if @rating.save
        render json: @rating, status: :created
        else
            render_json_success( @rating.errors.full_messages)
        end
    end

    def show
        render json: @rating
    end

    def index
        @ratings = DriverRideRating.where(ride_id: params[:ride_id])
        render json: @ratings
    end

    def update
        
    end

    def destroy
        
    end

    private

    def authorize_admin
        unless current_user.admin?
          render json: { error: 'Not authorized' }, status: :unauthorized
        end
    end

    def set_ride
        @ride = Ride.find(params[:ride_id])
    end

    def rating_params
        params.require(:driver_ride_rating).permit(:ride_id, :user_id, :driver_id, :rating_value, :comment)
    end

    
    def render_error(status, messages)
        render json: { error: messages }, status: status
    end
      
    def render_json_success(message, data = {})
        render json: { success: true, message: message, data: data }, status: :ok
    end 
end

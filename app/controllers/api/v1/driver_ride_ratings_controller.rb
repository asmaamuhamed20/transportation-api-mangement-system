class Api::V1::DriverRideRatingsController < ApplicationController
    before_action :set_ride
    before_action :authorize_admin, only: [:create]
  
    def create
      @rating = @ride.driver_ride_ratings.build(rating_params.merge(user: @ride.user, driver: @ride.driver))
  
      if @rating.save
        render json: { success: true, data: @rating }, status: :created
      else
        render_error(:unprocessable_entity, @rating.errors.full_messages)
      end
    end
  
    def show
      render json: { success: true, data: @rating }
    end
  
    def index
      @ratings = DriverRideRating.where(ride_id: params[:ride_id])
      render json: { success: true, data: @ratings }
    end
  
    private
  
    def authorize_admin
      unless current_user.admin?
        render_error(:unauthorized, 'Not authorized')
      end
    end
  
    def set_ride
      @ride = Ride.find(params[:ride_id])
    end
  
    def rating_params
        params.require(:rating).permit(:rating_value, :comment)
    end
      
  
    def render_error(status, message)
      render json: { success: false, error: message }, status: status
    end
end
  
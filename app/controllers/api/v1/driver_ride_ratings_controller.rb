class Api::V1::DriverRideRatingsController < ApplicationController
    before_action :set_ride, only: [:create]
    before_action :authorize_admin, only: [:average_rating_for_driver]
  
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
  
    def average_rating_for_driver
      driver_id = params[:id]
      ratings = DriverRideRating.where(driver_id: driver_id)
  
      if ratings.present?
        total_ratings = ratings.count
        sum_of_ratings = ratings.sum(:rating_value)
        average_rating = sum_of_ratings.to_f / total_ratings
  
        render_json_success({ driver_id: driver_id, average_rating: average_rating })
      else
        render_error(:not_found, 'No ratings available for the driver')
      end
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
  
    def render_json_success(data = {})
      render json: { success: true, data: data }, status: :ok
    end 
  end
  
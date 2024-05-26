class Api::V1::DriverRideRatingsController < ApplicationController
    before_action :set_ride, only: [:create]
    before_action :authorize_admin, only: [:average_rating_for_driver]
  
    # POST: /api/v1/driver_ride_ratings
    def create
      @rating = @ride.driver_ride_ratings.build(rating_params.merge(user: @ride.user, driver: @ride.driver))
      handle_rating_save_result(@rating)
    end
  
    # GET: /api/v1/driver_ride_ratings/2
    def show
      @rating = DriverRideRating.find(params[:id])
      render_success_json(data: @rating)
    end
  
    # GET: /api/v1/driver_ride_ratings?ride_id=1
    def index
      @ratings = DriverRideRating.where(ride_id: params[:ride_id])
      render_success_json(data: @ratings)
    end
  
    # GET: /api/v1/driver_ride_ratings/4/average_rating_for_driver
    def average_rating_for_driver
      driver_id = params[:id]
      ratings = DriverRideRating.where(driver_id: driver_id)
      calculate_and_render_average_rating(driver_id, ratings)
    end
  
    private
  
    def authorize_admin
      render_error(:unauthorized, 'Not authorized') unless current_user.admin?
    end
  
    def set_ride
      @ride = Ride.find(params[:ride_id])
    end
    
    def  handle_rating_save_result(result)
      if result.save
        render_success_json(data: result, status: :created)
      else
        render_error(:unprocessable_entity, result.errors.full_messages)
      end   
    end
  
    def rating_params
      params.require(:rating).permit(:rating_value, :comment)
    end

    def calculate_and_render_average_rating(driver_id, ratings)
      if ratings.present?
        total_ratings = ratings.count 
        sum_of_ratings = ratings.sum(:rating_value)
        average_rating = sum_of_ratings.to_f / total_ratings
        render_success_json(data: { driver_id: driver_id, average_rating: average_rating })
      else
        render_error(:not_found, 'No ratings available for the driver')
      end
    end
  
    def render_error(status, message)
      render json: { success: false, error: message }, status: status
    end
  
    def render_success_json(data: {}, status: :ok)
      render json: { success: true, data: data }, status: status
    end
  end
  
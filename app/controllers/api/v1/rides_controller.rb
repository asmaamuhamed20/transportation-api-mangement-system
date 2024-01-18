class Api::V1::RidesController < ApplicationController
    before_action :validate_vehicle_availability, only: [:create]
    def create
        ride = Ride.new(ride_params)
    
        if ride.save
          render json: ride, status: :created
        else
          render json: { errors: ride.errors.full_messages }, status: :unprocessable_entity
        end
    end
    
    private
    
    def ride_params
        params.require(:ride).permit(:user_id, :driver_id, :vehicle_id, :pickup_stop, :drop_off_stop, :start_time, :end_time, selected_user_ids: [])
    end

    def validate_vehicle_availability
        vehicle = Vehicle.find(params[:ride][:vehicle_id])
    
        unless vehicle.available?(params[:ride][:start_time], params[:ride][:end_time])
          render json: { errors: ['Selected vehicle is not available during this time'] }, status: :unprocessable_entity
        end
    end
end

class Api::V1::RidesController < ApplicationController
    before_action :validate_vehicle_availability, only: [:create]
    def create
        ride = Ride.new(ride_params)
        if vehicle_available?(ride)
            if ride.save
            render json: ride, status: :created
            else
            render json: { errors: ride.errors.full_messages }, status: :unprocessable_entity
            end
        else
            render json: { errors: ['selected vehicle is not available during this time']}, status: :unprocessable_entity
        end
    end
    
    private
    
    def ride_params
        params.require(:ride).permit(:user_id, :driver_id, :vehicle_id, :pickup_stop, :drop_off_stop, :start_time, :end_time)
    end

    def vehicle_available?(ride)
        vehicle = Vehicle.find(ride.vehicle_id)
        vehicle.available?(ride.start_time, ride.end_time)
    end
    
    def validate_vehicle_availability
        vehicle = Vehicle.find(params[:ride][:vehicle_id])
        ride = Ride.new(ride_params)
        
        unless vehicle_available?(ride)
          render json: { errors: ['Selected vehicle is not available during this time'] }, status: :unprocessable_entity
        end
    end      
end

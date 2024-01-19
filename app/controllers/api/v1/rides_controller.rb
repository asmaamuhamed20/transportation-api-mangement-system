class Api::V1::RidesController < ApplicationController
    before_action :validate_vehicle_availability, only: [:create]
    before_action :find_ride, only: [:swap_vehicle]

    def create
        ride = Ride.new(ride_params)
        if vehicle_available?(ride)
            if ride.save
            render json: ride, status: :created
            else
                render_unprocessable_entity(ride.errors.full_messages)
            end
        else
            render_error(:unprocessable_entity, 'Selected vehicle is not available during this time')
        end
    end
    
    def swap_vehicle
        new_vehicle_id = params[:new_vehicle_id]
        swap_vehicle = find_vehicle(new_vehicle_id)
      
        if swap_vehicle
          if @ride.update(vehicle: swap_vehicle)
            render json: { message: 'Vehicle swapped successfully', ride: @ride }, status: :ok
          else
            render_error(:unprocessable_entity, @ride.errors.full_messages)
          end
        else
            head :not_found
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
            render_unprocessable_entity('Selected vehicle is not available during this time')
        end
    end 

    def find_ride
        @ride = Ride.find(params[:id])
    end
    
    def find_vehicle(vehicle_id)
        vehicle = Vehicle.find_by(id: vehicle_id)
        
        unless vehicle
          head :not_found
          return
        end
      
        vehicle
    end
      
      
    def render_error(status, message)
        render json: { error: message }, status: status
    end  
    
    def render_ok(message)
        render json: { error: message }, status: :ok
    end
end

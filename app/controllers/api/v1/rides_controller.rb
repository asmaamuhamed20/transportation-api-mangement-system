class Api::V1::RidesController < ApplicationController
    before_action :validate_vehicle_availability, only: [:create]
    before_action :find_ride, only: [:swap_vehicle, :add_user_to_ride, :remove_user, :replace_user]

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

    def add_user_to_ride
        ride = find_ride
        user = find_user(params[:user_id])
        process_add_user(ride, user)
    end
      
    def remove_user
        ride = find_ride
        user = User.find(params[:user_id])
        process_remove_user(ride, user)
    end


    def replace_user
        new_user = find_user(params[:new_user_id])
    
        if @ride.replace_user(new_user)
          render_ok('User replaced in the ride successfully', ride: @ride)
        else
          render_error(:unprocessable_entity, 'Failed to replace user in the ride')
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
      
      
    def render_error(status, messages)
        render json: { error: messages }, status: status
    end
      
    
    def render_ok(message, data = {})
        render json: { success: true, message: message, data: data }, status: :ok
    end

    def find_user(user_id)
        User.find(user_id)
    end

    def process_add_user(ride, user)
        if ride.add_user(user)
          render json: { message: 'User added to the ride successfully', ride: ride }, status: :ok
        else
          render_error(:unprocessable_entity, 'Failed to add user to the ride')
        end
    end

    def process_remove_user(ride, user)
        if ride.remove_user(user)
          render_ok('User removed from the ride successfully')
        else
          render_error(:unprocessable_entity, { error: 'Failed to remove user from the ride', errors: ride.errors.full_messages })
        end
    end

end

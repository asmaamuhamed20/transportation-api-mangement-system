class Api::V1::RidesController < ApplicationController
    before_action :validate_vehicle_availability, only: [:create]
    before_action :find_ride, only: [:swap_vehicle, :add_user_to_ride, :remove_user, :replace_user]
    before_action :find_driver, only: [:rides_for_driver]
    before_action :find_user, only: [:rides_for_user]
    before_action :authorize_admin, only: [:create, :swap_vehicle, :add_user_to_ride, :remove_user, :replace_user, :rides_for_date, :rides_for_driver, :rides_for_time_range, :complete_ride]
    load_and_authorize_resource
    
    def index  #user
        rides = Ride.all
        render_json_success(rides: rides)
    end

    def create
        ride = Ride.new(ride_params)
        ride.status = :active
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

    def show
        
    end


    def replace_user
        new_user = find_user(params[:new_user_id])
    
        if @ride.replace_user(new_user)
          render_json_success('User replaced in the ride successfully', ride: @ride)
        else
          render_error(:unprocessable_entity, 'Failed to replace user in the ride')
        end
    end

    def rides_for_driver
        rides = Ride.where(driver: @driver)
        render json: rides, status: :ok
    end

    def rides_for_user
        user = User.find(params[:user_id])
        rides = user.rides
        render json: rides, status: :ok
    end

    def rides_for_date
        rides = Ride.where('DATE(start_time) = ?', params[:date])
        render json: rides, status: :ok
    end

    def rides_for_time_range
        rides = Ride.where('start_time >= ? AND end_time <= ?', params[:start_time], params[:end_time])
        render json: rides, status: :ok
    end

    def complete_ride
        @ride = Ride.find(params[:id])
        @ride.update(status: :completed)
        render_json_success('Ride completed successfully', ride: @ride)
    end
      
                
    private
    
    def authorize_admin
        unless current_user.admin?
          render json: { error: 'Not authorized' }, status: :unauthorized
        end
    end
    
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

    def find_driver
        @driver = Driver.find_by(id: params[:driver_id])
    
        unless @driver
          render_error(:not_found, 'Driver not found')
        end
    end
      
      
    def render_error(status, messages)
        render json: { error: messages }, status: status
    end
      
    
    def render_json_success(message, data = {})
        render json: { success: true, message: message, data: data }, status: :ok
    end

    def find_user
        @user = User.find_by(id: params[:user_id])
    
        unless @user
          render_error(:not_found, 'User not found')
        end
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
          render_json_success('User removed from the ride successfully')
        else
          render_error(:unprocessable_entity, { error: 'Failed to remove user from the ride', errors: ride.errors.full_messages })
        end
    end

end

class Api::V1::RidesController < ApplicationController
    before_action :validate_vehicle_availability, only: [:create]
    before_action :find_ride, only: [:swap_vehicle, :add_user_to_ride, :remove_user, :replace_user, :destroy, :complete_ride]
    before_action :find_user, only: [:rides_for_user]
    before_action :authorize_admin, only: [:create, :swap_vehicle, :add_user_to_ride, :remove_user, :replace_user, :rides_for_date, :rides_for_user, :rides_for_time_range, :complete_ride]

    
    def index
        @rides_with_invoices = Ride.includes(:invoice)
        render json: @rides_with_invoices, include: :invoice, methods: :distance
    end

    # POST: /api/v1/rides
    def create
        result = Ride.save_ride(ride_params)

        if result[:status] == :created
            render json: {
              ride: result[:ride].as_json(except: :coupon_id),
              invoice: result[:invoice].as_json(except: :discount)
            }, status: result[:status]
        else
            render json: { error: result[:message] || result[:errors] }, status: result[:status]
        end
    end

    # DELETE: /api/v1/rides
    def destroy
        if @ride.destroy
            render_json_success('Ride deleted successfully')
        else
            render_error(:unprocessable_entity, 'Failed to delete ride')
        end   
    end
    
    # PATCH: /api/v1/rides/20/swap_vehicle
    def swap_vehicle
        result = @ride.swap_vehicle(params[:new_vehicle_id])
        if result[:status] == :ok
          render_json_success(result[:message], ride: result[:ride])
        else
          render_error(result[:status], result[:message])
        end
    end

    # POST: /api/v1/rides/20/add_user
    def add_user_to_ride
        user = find_user(params[:user_id])
        process_add_user(user)
    end
    
    # DELETE: /api/v1/rides/20/remove_user
    def remove_user
        user = find_user(params[:user_id])
        process_remove_user(user)
    end

    # POST: /api/v1/rides/21/replace_user
    def replace_user
        if @ride.replace_user(params[:new_user_id])
          render_json_success('User replaced in the ride successfully', ride: @ride)
        else
          render_error(:not_found, 'User not found')
        end
    end
      
    def rides_for_user
        rides = Ride.where(user_id: @user.id)
        render json: rides, status: :ok, methods: :distance
    end

    # GET: /api/v1/rides/1/rides_for_date?date=2024-01-19
    def rides_for_date
        rides = Ride.where('DATE(start_time) = ?', params[:date])
        render json: rides, status: :ok, methods: :distance
    end


    # GET: /api/v1/rides/8/rides_for_time_range?start_time=2024-01-18T10:00:00Z&end_time=2024-01-20T18:00:00Z
    def rides_for_time_range
        rides = Ride.where('start_time >= ? AND end_time <= ?', params[:start_time], params[:end_time])
        render json: rides, status: :ok, methods: :distance
    end

    # POST: /api/v1/rides/20/complete_ride    
    def complete_ride
        result = @ride.complete
        render json: result, status: result[:status]
    end
                
    private
    
    def authorize_admin
        render_error(:unauthorized, 'Not authorized') unless current_user.admin?
    end
    
    def ride_params
        params.require(:ride).permit(:user_id, :driver_id, :vehicle_id, :pickup_stop, :drop_off_stop, :start_time, :end_time)
    end
    
    def validate_vehicle_availability
        ride = Ride.new(ride_params)   
        render_vehicle_unavailable_error unless vehicle_available?(ride)
    end

    def render_vehicle_unavailable_error
        render_error(:unprocessable_entity, 'Selected vehicle is not available during this time')
    end
   
    def find_ride
        @ride = Ride.find(params[:id])
    end
    
    
    def find_user(user_id)
        user = User.find_by(id: user_id)
        render_error(:not_found, 'User not found') unless user
    end

    def process_add_user(user)
        if @ride.add_user(user)
          render_json_success('User added to the ride successfully', ride: @ride)
        else
          render_error(:unprocessable_entity, 'Failed to add user to the ride')
        end
    end

    def process_remove_user(user)
        if @ride.remove_user(user)
          render_json_success('User removed from the ride successfully')
        else
          render_error(:unprocessable_entity, { error: 'Failed to remove user from the ride', errors: ride.errors.full_messages })
        end
    end
      
    def render_error(status, messages)
        render json: { error: messages }, status: status
    end
      
    
    def render_json_success(message, data = {})
        render json: { success: true, message: message, data: data }, status: :ok
    end
end

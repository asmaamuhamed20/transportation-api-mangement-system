module Api
    module V1
      class VehiclesController < ApplicationController
        before_action :set_vehicle, only: [:show, :edit, :update, :destroy]
        before_action :authorize_admin
  
        def index
          render json: Vehicle.all
        end
  
        def show
          render json: @vehicle
        end
  
        def new
          @vehicle = Vehicle.new
        end
  
        def create
          @vehicle = Vehicle.new(vehicle_params)
          if @vehicle.save
            render json: @vehicle, status: :created
          else
            render json: { error: @vehicle.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        def edit
            
        end
  
        def update
          if @vehicle.update(vehicle_params)
            render json: @vehicle
          else
            render json: { error: @vehicle.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        def destroy
          if @vehicle.destroy
            render json: { success: true, message: 'Vehicle removed successfully' }, status: :ok
          else
            render json: { error: @vehicle.errors.full_messages }, status: :unprocessable_entity
          end
        end
  
        private
        
        def authorize_admin
          unless current_user.admin?
            render json: { error: 'Not authorized' }, status: :unauthorized
          end
        end
        def set_vehicle
          @vehicle = Vehicle.find(params[:id])
        end
  
        def vehicle_params
          params.require(:vehicle).permit(:model, :registration_number, :driver_id, :available_time)
        end
      end
    end
end
  
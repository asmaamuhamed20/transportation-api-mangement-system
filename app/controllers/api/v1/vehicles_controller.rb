class Api::V1::VehiclesController < ApplicationController
  before_action :set_vehicle, only: [:show, :update, :destroy]
  before_action :authorize_admin,  only: [:create, :update, :destroy]

  # GET: /api/v1/vehicles
  def index
    render json: Vehicle.all
  end

  def show
    render_json_success(@vehicle)
  end

  def new
    @vehicle = Vehicle.new
  end

  # POST: /api/v1/vehicles
  def create
    @vehicle = Vehicle.create_vehicle(vehicle_params)
    handle_vehicle_response(@vehicle)
  end

  # PUT: /api/v1/vehicles/:vehicle_id
  def update
    @vehicle.update_vehicle(vehicle_params)
    handle_vehicle_response(@vehicle)
  end

  # DELETE: /api/v1/vehicles/:vehicle_id
  def destroy
    Vehicle.destroy_vehicle(@vehicle)
    render_json_success(message: 'Vehicle removed successfully')
  end

  private
  

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def authorize_admin
    render_json_error('Not authorized', :unauthorized) unless current_user.admin?
  end

  def vehicle_params
    params.require(:vehicle).permit(:model, :registration_number, :driver_id, :available_time)
  end

  def handle_vehicle_response(vehicle)
    if vehicle.valid?
      render_json_success(vehicle)
    else
      render_json_error(vehicle.errors.full_messages.join(', '), :unprocessable_entity)
    end
  end

  def render_json_success(data, status = :ok)
    render json: { success: true, data: data }, status: status
  end

  def render_json_error(message, status = :unprocessable_entity)
    render json: { success: false, error: message }, status: status
  end
end
  
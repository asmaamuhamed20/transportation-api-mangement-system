class Api::V1::DriversController < ApplicationController
    before_action :find_driver, only: [:update, :destroy, :rides_for_driver]   
    before_action :authorize_admin, only: [:create, :update, :destroy, :rides_for_driver] 


   #  GET: /api/v1/drivers
    def index
        render json: Driver.all
    end

    # POST: /api/v1/drivers
    def create
        result = Driver.create_driver(driver_params)
        if result[:status] == :created
          render_created(result[:driver])
        else
          render_error(:unprocessable_entity, result[:errors])
        end
    end

    # PUT: /api/v1/drivers/5
    def update
        result = @driver.update_driver(driver_params)
        if result[:status] == :ok
          render json: result[:driver], status: :ok
        else
          render_unprocessable_entity(result[:errors])
        end
    end

    # DELETE: /api/v1/drivers/5
    def destroy
        result = @driver.destroy_driver
        head result[:status]
    end

    # GET: /api/v1/drivers/2/rides_for_driver    
    def rides_for_driver
        render json: @driver.rides, status: :ok
    end

    private

    def authorize_admin
        render_unauthorized('Not authorized') unless current_user.admin?
    end

    def driver_params
        params.require(:driver).permit(:driver_name)
    end

    def find_driver
        @driver = Driver.find_by(id: params[:id])
        render_not_found('Driver not found') unless @driver
    end

    def render_unprocessable_entity(messages)
        render json: { error: messages }, status: :unprocessable_entity
    end
      
    def render_created(driver)
        render json: { success: true, message: 'Driver created successfully', driver: driver }, status: :created
    end

    def render_unauthorized(message)
        render json: { error: message }, status: :unauthorized
    end

    def render_not_found(message)
        render json: { error: message }, status: :not_found
    end
end
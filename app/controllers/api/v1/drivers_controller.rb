class Api::V1::DriversController < ApplicationController
    before_action :find_driver, only: [:update, :destroy, :rides_for_driver]   
    before_action :authorize_admin, only: [:create, :update, :destroy, :rides_for_driver] 
   # load_and_authorize_resource

   #  GET: http://localhost:3000/api/v1/drivers
    def index
        render json: Driver.all
    end

    # POST: http://localhost:3000/api/v1/drivers
    def create
        @driver = Driver.new(driver_params)
        if @driver.save
            render_created(@driver)
        else
          render_error(:unprocessable_entity, @driver.errors.full_messages)
        end
    end

    # PUT: http://localhost:3000/api/v1/drivers/5
    def update
        if @driver.update(driver_params)
            render json: @driver, status: :ok
        else
            render_unprocessable_entity(@driver.errors.full_messages)
        end
    end

    # DELETE: http://localhost:3000/api/v1/drivers/5
    def destroy
        @driver.destroy
        head :no_content   
    end

    # GET: http://localhost:3000/api/v1/drivers/2/rides_for_driver    
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
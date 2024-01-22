class Api::V1::DriversController < ApplicationController
    before_action :find_driver, only: [:rides_for_driver]   
    before_action :authorize_admin, only: [:create, :rides_for_driver] 
    load_and_authorize_resource

    def index
        render json: Driver.all
    end

    def show
        @driver = Driver.find(params[:id])
        @average_rating = @driver.average_rating
        render json: { driver: @driver, average_rating: @average_rating }
    end

    def rides_for_driver
        rides = Ride.where(driver: @driver)
        render json: rides, status: :ok
    end

    def new
        
    end

    def create
        @driver = Driver.new(driver_params)

        if @driver.save
          render_json_success('Driver created successfully', driver: @driver)
        else
          render_error(:unprocessable_entity, @driver.errors.full_messages)
        end
    end

    def edit
        
    end

    def update
        
    end

    def destroy
        
    end

    private

    def authorize_admin
        unless current_user.admin?
          render json: { error: 'Not authorized' }, status: :unauthorized
        end
    end

    def driver_params
        params.require(:driver).permit(:driver_name)
    end

    def find_driver
        @driver = Driver.find_by(id: params[:id])
    
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

end
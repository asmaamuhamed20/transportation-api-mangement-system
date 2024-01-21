class Api::V1::DriversController < ApplicationController

    def index
        render json: Driver.all
    end

    def show
        @driver = Driver.find(params[:id])
        @average_rating = @driver.average_rating
        render json: { driver: @driver, average_rating: @average_rating }
    end

    def new
        
    end

    def create
        
    end

    def edit
        
    end

    def update
        
    end

    def destroy
        
    end

    private

end

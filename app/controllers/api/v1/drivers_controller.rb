class Api::V1::DriversController < ApplicationController

    def index
        render json: Driver.all
    end

    def show
        
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

    def average_rating
        @driver = Driver.find(params[:id])
        @average_rating = @driver.ratings.average(:rating_value)
        render json: { average_rating: @average_rating }
    end

    private

end

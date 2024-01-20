class Api::V1::DriversController < ApplicationController
    access all: [:show, :index], user: {except: [:destroy, :new, :create, :update, :edit]}, admin: :all
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
end

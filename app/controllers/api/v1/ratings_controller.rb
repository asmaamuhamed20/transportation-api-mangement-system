class RatingsController < ApplicationController
    before_action :set_rating, only: [:show, :update, :destroy]
    
    def create
        @rating = Rating.new(rating_params)

        if @rating.save
        render json: @rating, status: :created
        else
        render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def show
        render json: @rating
    end

    def index
        @ratings = Rating.where(ride_id: params[:ride_id])
        render json: @ratings
    end

    private

    def set_rating
        @rating = Rating.find(params[:id])
    end

    def rating_params
        params.require(:rating).permit(:ride_id, :user_id, :driver_id, :rating_value, :comment)
    end
end

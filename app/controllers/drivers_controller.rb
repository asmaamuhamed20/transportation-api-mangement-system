class DriversController < ApplicationController
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
end

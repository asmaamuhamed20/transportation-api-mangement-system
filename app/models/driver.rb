class Driver < ApplicationRecord
    has_one :vehicle
    
    has_many :rides
    has_many :user_ratings
    has_many :driver_ride_ratings
    has_many :invoices
    has_many :driver_payments

    validates :driver_name, presence: true

    def create_driver(driver_params)
        driver = Driver.new(driver_params)
        if driver.save
          { status: :created, driver: driver }
        else
          { status: :unprocessable_entity, errors: driver.errors.full_messages }
        end
    end


    def update_driver(driver_params)
        if update(driver_params)
          { status: :ok, driver: self }
        else
          { status: :unprocessable_entity, errors: errors.full_messages }
        end
    end
    
    def destroy_driver
        destroy
        { status: :no_content }
    end
end

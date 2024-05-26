class Driver < ApplicationRecord
    has_one :vehicle
    
    has_many :rides
    has_many :user_ratings
    has_many :driver_ride_ratings
    has_many :invoices
    has_many :driver_payments
end

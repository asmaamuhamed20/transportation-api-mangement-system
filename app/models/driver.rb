class Driver < ApplicationRecord
    has_one :vehicle
    has_many :rides
    has_many :ride_reviews
    has_many :ratings, through: :ride_reviews
end

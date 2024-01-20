class Driver < ApplicationRecord
    has_one :vehicle
<<<<<<< HEAD
    has_many :ratings
=======
    has_many :rides
    has_many :ride_reviews
    has_many :ratings, through: :ride_reviews
>>>>>>> system-statistics
end

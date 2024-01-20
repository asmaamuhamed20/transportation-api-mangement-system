class Driver < ApplicationRecord
    has_one :vehicle
<<<<<<< HEAD
    has_many :ratings
=======
    has_many :rides
    has_many :ratings, through: :rides, source: :ratings
>>>>>>> system-statistics
end

class Driver < ApplicationRecord
    has_one :vehicle
    has_many :rides
    has_many :ratings, through: :rides, source: :ratings
end

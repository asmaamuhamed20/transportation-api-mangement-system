class Driver < ApplicationRecord
    has_one :vehicle
    has_many :rides
end

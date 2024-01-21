class DriverRideRating < ApplicationRecord
  belongs_to :ride
  belongs_to :user
  belongs_to :driver
end

class UserRating < ApplicationRecord
  belongs_to :ride
  belongs_to :user
  belongs_to :driver
  has_many :driver_ride_ratings, dependent: :destroy
end

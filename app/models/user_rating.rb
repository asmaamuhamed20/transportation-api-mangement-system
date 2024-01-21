class UserRating < ApplicationRecord
  belongs_to :ride
  belongs_to :user
  has_many :driver_ride_ratings, dependent: :destroy
end

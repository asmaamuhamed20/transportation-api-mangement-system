class RideReview < ApplicationRecord
  belongs_to :ride
  belongs_to :user
  belongs_to :driver
  validates :rating, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
end

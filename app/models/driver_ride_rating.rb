class DriverRideRating < ApplicationRecord
  belongs_to :ride

  validates :rating_value, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :comment, presence: true


  def self.create_rating(ride, rating_params)
    rating = ride.driver_ride_ratings.build(rating_params.merge(user: ride.user, driver: ride.driver))
    rating.save
    rating
  end

  def self.average_rating_for_driver(driver_id)
    ratings = where(driver_id: driver_id)
    return nil if ratings.empty?

    total_ratings = ratings.count
    sum_of_ratings = ratings.sum(:rating_value)
    sum_of_ratings.to_f / total_ratings
  end

  def self.ratings_for_ride(ride_id)
    where(ride_id: ride_id)
  end

  def user
    ride.user
  end

  def driver
    ride.driver
  end
end

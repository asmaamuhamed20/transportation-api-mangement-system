class Driver < ApplicationRecord
    has_one :vehicle
    has_many :rides
    has_many :ride_reviews
    has_many :ratings

    def average_rating
        user_ratings = ratings.average(:rating_value) || 0
        driver_ratings = ride_reviews.average(:rating) || 0
    
        total_ratings = user_ratings + driver_ratings
        total_reviews = ratings.count + ride_reviews.count
    
        total_reviews > 0 ? total_ratings / total_reviews.to_f : 0
    end
end

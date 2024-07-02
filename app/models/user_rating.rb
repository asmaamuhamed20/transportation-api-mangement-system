class UserRating < ApplicationRecord
  belongs_to :ride
  belongs_to :user

  validates :comment, presence: true
  validates :rating, presence: true, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }

  def self.create_user_rating(ride, user_rating_params, user)
    return { success: false, error: "Current user is not allowed to rate this ride" } unless ride.can_be_rated_by?(user)

    user_rating = ride.user_ratings.build(user_rating_params.merge(user_id: user.id))

    if user_rating.save
      { success: true, user_rating: user_rating }
    else
      { success: false, error: user_rating.errors.full_messages }
    end
  end

  def self.average_rating_by_user(user_id)
    user_ratings = where(user_id: user_id)
    if user_ratings.present?
      total_ratings = user_ratings.count
      sum_of_ratings = user_ratings.sum(:rating)
      average_rating = sum_of_ratings.to_f / total_ratings
      { success: true, average_rating: average_rating }
    else
      { success: false, error: 'No ratings available for the user' }
    end
  end
end

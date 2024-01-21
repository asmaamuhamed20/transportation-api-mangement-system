class RenameRideReviewsToUserRatings < ActiveRecord::Migration[7.1]
  def change
    rename_table :ride_reviews, :user_ratings
  end
end

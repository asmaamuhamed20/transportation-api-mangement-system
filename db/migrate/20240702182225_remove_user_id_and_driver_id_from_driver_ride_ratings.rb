class RemoveUserIdAndDriverIdFromDriverRideRatings < ActiveRecord::Migration[7.1]
  def change
    remove_column :driver_ride_ratings, :user_id, :integer
    remove_column :driver_ride_ratings, :driver_id, :integer
  end
end

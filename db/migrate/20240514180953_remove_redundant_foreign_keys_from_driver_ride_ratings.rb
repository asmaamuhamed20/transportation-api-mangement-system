class RemoveRedundantForeignKeysFromDriverRideRatings < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :driver_ride_ratings, :rides
    remove_foreign_key :driver_ride_ratings, :users
  end
end

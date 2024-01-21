class ChangeRatingsTable < ActiveRecord::Migration[7.1]
  def change
    rename_table :ratings, :driver_ride_ratings
  end
end

class RemoveCoordinatesToRidesTable < ActiveRecord::Migration[7.1]
  def change
    remove_column :rides, :pickup_latitude, :float
    remove_column :rides, :pickup_longitude, :float
    remove_column :rides, :dropoff_latitude, :float
    remove_column :rides, :dropoff_longitude, :float
  end
end

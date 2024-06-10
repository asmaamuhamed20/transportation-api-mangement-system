class AddCoordinatesToRides < ActiveRecord::Migration[6.0]
  def change
    add_column :rides, :pickup_latitude, :float
    add_column :rides, :pickup_longitude, :float
    add_column :rides, :dropoff_latitude, :float
    add_column :rides, :dropoff_longitude, :float
  end
end

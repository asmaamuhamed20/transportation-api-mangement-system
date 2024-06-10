class ModifyRides < ActiveRecord::Migration[7.1]
  def change
    remove_column :rides, :latitude
    remove_column :rides, :longitude
    remove_column :rides, :pickup_latitude
    remove_column :rides, :pickup_longitude
    remove_column :rides, :dropoff_latitude
    remove_column :rides, :dropoff_longitude
    remove_index :rides, name: "index_rides_on_driver_id"
    remove_index :rides, name: "index_rides_on_user_id"
    remove_index :rides, name: "index_rides_on_vehicle_id"

    add_column :rides, :pickup_location, :point
    add_column :rides, :dropoff_location, :point
    add_index :rides, :driver_id
    add_index :rides, :user_id
    add_index :rides, :vehicle_id
  end
end

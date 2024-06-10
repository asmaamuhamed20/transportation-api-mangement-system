class RemovePickupAndDropoffLocationsFromRides < ActiveRecord::Migration[7.1]
  def change
    remove_column :rides, :pickup_location
    remove_column :rides, :dropoff_location
  end
end

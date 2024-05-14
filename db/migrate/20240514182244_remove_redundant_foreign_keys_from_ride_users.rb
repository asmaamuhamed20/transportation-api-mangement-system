class RemoveRedundantForeignKeysFromRideUsers < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key :ride_users, :rides
    remove_foreign_key :ride_users, :users
  end
end

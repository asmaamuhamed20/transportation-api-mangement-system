class AddForeignKeyConstraints < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :rides, :users
    add_foreign_key :ride_users, :rides
    add_foreign_key :ride_users, :users
    add_foreign_key :driver_ride_ratings, :rides
    add_foreign_key :driver_ride_ratings, :users
  end
end

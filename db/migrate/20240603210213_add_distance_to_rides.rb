class AddDistanceToRides < ActiveRecord::Migration[7.1]
  def change
    add_column :rides, :distance, :decimal
  end
end

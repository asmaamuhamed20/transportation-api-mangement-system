class AddStatusToRides < ActiveRecord::Migration[7.1]
  def change
    add_column :rides, :status, :integer
  end
end

class AddRatingToRides < ActiveRecord::Migration[7.1]
  def change
    add_column :rides, :rating, :integer
  end
end

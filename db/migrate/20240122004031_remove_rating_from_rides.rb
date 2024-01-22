class RemoveRatingFromRides < ActiveRecord::Migration[7.1]
  def change
    remove_column :rides, :rating, :integer
  end
end

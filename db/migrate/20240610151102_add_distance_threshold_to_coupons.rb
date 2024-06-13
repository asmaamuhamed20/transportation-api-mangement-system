class AddDistanceThresholdToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :distance_threshold, :float
  end
end

class AddDefaultsToCoupons < ActiveRecord::Migration[7.1]
  def change
    change_column_default :coupons, :usage_count, 0
  end
end

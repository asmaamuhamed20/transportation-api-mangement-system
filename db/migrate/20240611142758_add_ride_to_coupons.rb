class AddRideToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_reference :coupons, :ride, foreign_key: true, null: true
  end
end

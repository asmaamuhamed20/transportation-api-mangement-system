class RemoveCouponIdFromRides < ActiveRecord::Migration[7.1]
  def change
    remove_reference :rides, :coupon, null: false, foreign_key: true
  end
end

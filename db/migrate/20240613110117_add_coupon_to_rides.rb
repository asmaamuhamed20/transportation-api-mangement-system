class AddCouponToRides < ActiveRecord::Migration[7.1]
  def change
    add_reference :rides, :coupon, foreign_key: true
  end
end

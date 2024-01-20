class AddDefaultStatusToRides < ActiveRecord::Migration[7.1]
  def up
    Ride.where(status: nil).update_all(status: 0)
  end
end

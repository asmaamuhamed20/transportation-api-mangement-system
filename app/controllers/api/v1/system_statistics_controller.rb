class Api::V1::SystemStatisticsController < ApplicationController
  def total_rides_count
    total_rides = Ride.count
    render json: { total_rides: total_rides }
  end
end

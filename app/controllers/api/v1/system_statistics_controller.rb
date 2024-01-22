class Api::V1::SystemStatisticsController < ApplicationController
  before_action :authorize_admin, only: [:total_rides_count, :daily_rides_count, :total_drivers_count] 


  def total_rides_count
    total_rides = Ride.count
    render json: { total_rides: total_rides }
  end

  def daily_rides_count
    start_date = Date.parse('2024-01-18')
    end_date = Date.today 
    daily_counts = {}
    (start_date..end_date).each do |date|
      rides_count = Ride.where('DATE(created_at) = ?', date).count
      daily_counts[date.to_s] = rides_count
    end
    render_json_success(daily_rides_count: daily_counts)
  end

  def total_drivers_count
    total_drivers = Driver.count
    render_json_success(total_drivers: total_drivers) 
  end

  private

  def authorize_admin
    unless current_user.admin?
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end

  def render_json_success(data, status = :ok)
    render json: { success: true, data: data }, status: status
  end

end

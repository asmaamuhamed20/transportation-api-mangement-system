class Api::V1::SystemStatisticsController < ApplicationController
  before_action :authorize_admin

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

  def  highest_rides_users
    highest_rides_users = User.joins(:rides).group('users.id').order('COUNT(rides.id) DESC').limit(1)
    render_json_success(highest_rides_users: highest_rides_users)
  end

  def highest_rides_drivers
    highest_rides_drivers = Driver.joins(:rides).group('drivers.id').order('COUNT(rides.id) DESC').limit(1)
    render_json_success(highest_rides_drivers: highest_rides_drivers) 
  end

  def usage_percentage
    total_used_time_by_vehicle = calculate_total_used_time
    usage_percentage_by_vehicle = {}
  
    total_used_time_by_vehicle.each do |vehicle_id, total_used_time|
      total_available_time = 100.hours.to_i
      unless total_available_time.zero?
        usage_percentage = (total_used_time.to_f / total_available_time) * 100
        usage_percentage_by_vehicle[vehicle_id] = usage_percentage
      end
    end
  
    render_json_success({ usage_percentage_by_vehicle: usage_percentage_by_vehicle })
  end

  private

  def authorize_admin
    unless current_user.admin?
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end

  def calculate_total_time(start_time, end_time)
    return 0 if start_time.nil? || end_time.nil?
    total_seconds = (end_time - start_time).to_i
  end

  def calculate_total_used_time
    total_used_time_by_vehicle = {}

    Ride.all.each do |ride|
      vehicle_id = ride.vehicle_id
      total_used_time_by_vehicle[vehicle_id] ||= 0
      total_used_time_by_vehicle[vehicle_id] += calculate_total_time(ride.start_time, ride.end_time)
    end
  
    total_used_time_by_vehicle
  end

  def calculate_usage_percentage(total_used_time)
    total_available_time = 100.hours.to_i
    return 0 if total_available_time.zero?
    (total_used_time.to_f / total_available_time) * 100
  end

  def render_json_success(data, status = :ok)
    render json: { success: true, data: data }, status: status
  end
end

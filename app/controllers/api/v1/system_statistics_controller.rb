class Api::V1::SystemStatisticsController < ApplicationController
  before_action :authorize_admin

  def total_rides_count
    total_rides = Ride.count
    render json: { total_rides: total_rides }
  end

  def daily_rides_count
    start_date = Date.parse('2024-01-01')
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

  def highest_rides_users_by_month
    month = params[:month].to_i
    year = params[:year].to_i
    highest_rides_users = find_highest_rides_users_by_month(month, year)
    if highest_rides_users
      render_json_success(highest_rides_users_by_month: highest_rides_users)
    else
      render_json_error("No data found for the specified month and year", :not_found)
    end
  end

  def highest_rides_drivers
    highest_rides_drivers = Driver.joins(:rides).group('drivers.id').order('COUNT(rides.id) DESC').limit(1)
    render_json_success(highest_rides_drivers: highest_rides_drivers) 
  end

  def highest_rides_drivers_by_month
    month = params[:month].to_i
    year = params[:year].to_i
    highest_rides_drivers = find_highest_rides_drivers_by_month(month, year)
    if highest_rides_drivers
      render_json_success(highest_rides_drivers_by_month: highest_rides_drivers)
    else
      render_json_error("No data found for the specified month and year", :not_found)
    end
  end

  def usage_percentage
    usage_percentage_by_vehicle = {}

    Vehicle.all.each do |vehicle|
      total_used_time = calculate_total_used_time(vehicle)
      total_available_time = calculate_total_available_time(vehicle)
  
      next if total_available_time.zero?
  
      usage_percentage = (total_used_time.to_f / total_available_time) * 100
      usage_percentage_by_vehicle[vehicle.id] = usage_percentage
    end
  
    render_json_success(usage_percentage_by_vehicle: usage_percentage_by_vehicle)
  end

  def rides_for_driver  #count rides for each driver
    driver_id = params[:driver_id]
    ride_count = Ride.where(driver_id: driver_id).count
    render_json_success({ driver_id: driver_id, ride_count: ride_count })
  end


  private

  def authorize_admin
    unless current_user.admin?
      render json: { error: 'Not authorized' }, status: :unauthorized
    end
  end

  def calculate_total_time(start_time, end_time)
    return 0 if start_time.nil? || end_time.nil?
     (end_time - start_time).to_i
  end

  def calculate_total_used_time(vehicle)
    total_used_time_by_vehicle = {}

    total_used_time = 0

    vehicle.rides.each do |ride|
      total_used_time += calculate_total_time(ride.start_time, ride.end_time)
    end
    total_used_time
  end

  def calculate_total_available_time(vehicle)
    total_available_time = 0
  
    vehicle.available_time_slots.each do |time_slot|
      start_time = time_slot.first
      end_time = time_slot.last
  
      next if start_time.nil? || end_time.nil?
  
      total_available_time += (end_time - start_time).to_i
    end
  
    total_available_time
  end

  def find_highest_rides_users_by_month(month, year)
    User.joins(:rides)
        .where(rides: { start_time: (Time.zone.parse("#{year}-#{month}-01")..Time.zone.parse("#{year}-#{month}-31 23:59:59")) })
        .group(:id)
        .order('COUNT(rides.id) DESC')
        .first
  end

  def find_highest_rides_drivers_by_month(month, year)
    Driver.joins(:rides)
          .where(rides: { start_time: (Time.zone.parse("#{year}-#{month}-01")..Time.zone.parse("#{year}-#{month}-31 23:59:59")) })
          .group(:id)
          .order('COUNT(rides.id) DESC')
          .first
  end
  

  def render_json_success(data, status = :ok)
    render json: { success: true, data: data }, status: status
  end

  def render_json_error(message, status = :unprocessable_entity)
    render json: { success: false, error: message }, status: status
  end
end

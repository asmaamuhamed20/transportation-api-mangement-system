class Api::V1::SystemStatisticsController < ApplicationController
  before_action :authorize_admin

  # GET: /api/v1/system_statistics/total_rides_count
  def total_rides_count
    render json: { total_rides: Ride.count }
  end

  # GET: /api/v1/system_statistics/daily_rides_count
  def daily_rides_count
    start_date = Date.parse('2024-01-01')
    end_date = Date.today 
    daily_counts = calculate_daily_rides_count(start_date, end_date)
    render_json_success(daily_rides_count: daily_counts)
  end

  # GET: /api/v1/system_statistics/total_drivers_count
  def total_drivers_count
    render_json_success(total_drivers: Driver.count) 
  end

  # GET: /api/v1/system_statistics/highest_rides_users
  def  highest_rides_users
    highest_rides_users = User.joins(:rides).group('users.id').order('COUNT(rides.id) DESC').limit(1)
    render_json_success(highest_rides_users: highest_rides_users)
  end

  # GET: /api/v1/system_statistics/highest_rides_users_by_month/:date
  def highest_rides_users_by_month
    month = params[:month].to_i
    year = params[:year].to_i
    highest_rides_users = find_highest_rides_users_by_month(month, year)
    render_highest_rides_by_month(User, highest_rides_users, :highest_rides_users_by_month)
  end

  # GET: /api/v1/system_statistics/highest_rides_drivers
  def highest_rides_drivers
    highest_rides_drivers = Driver.joins(:rides).group('drivers.id').order('COUNT(rides.id) DESC').limit(1)
    render_json_success(highest_rides_drivers: highest_rides_drivers)
  end

  # GET: /api/v1/system_statistics/highest_rides_drivers_by_month/date
  def highest_rides_drivers_by_month
    month = params[:month].to_i
    year = params[:year].to_i
    highest_rides_drivers = find_highest_rides_drivers_by_month(month, year)
    render_highest_rides_by_month(highest_rides_drivers, highest_rides_drivers, :highest_rides_drivers_by_month)
  end

  # GET: /api/v1/system_statistics/calculate_usage_percentage
  def calculate_usage_percentage
    usage_percentage_by_vehicle = calculate_usage_percentage_by_vehicle
    render_json_success(usage_percentage_by_vehicle: usage_percentage_by_vehicle)
  end   

  # GET: /api/v1/system_statistics/rides_for_driver?driver_id=
  def rides_for_driver 
    driver_id = params[:driver_id]
    ride_count = Ride.where(driver_id: driver_id).count
    render_json_success({ driver_id: driver_id, ride_count: ride_count })
  end


  private


  def authorize_admin
    render_unauthorized unless current_user.admin?
  end

  def calculate_daily_rides_count(start_date, end_date)
    daily_counts = {}
    (start_date..end_date).each do |date|
      rides_count = Ride.where('DATE(created_at) = ?', date).count
      daily_counts[date.to_s] = rides_count
    end
    daily_counts    
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

  def render_highest_rides_by_month(model, data, key)
    if data
      render_json_success({ key => data })
    else
      render_json_error("No data found for the specified month and year", :not_found)
    end
  end
  

  def calculate_usage_percentage_by_vehicle
    usage_percentage_by_vehicle = {}
    Vehicle.all.each do |vehicle|
      usage_percentage_by_vehicle[vehicle.id] = calculate_vehicle_usage_percentage(vehicle)
    end
    usage_percentage_by_vehicle
  end

  def calculate_vehicle_usage_percentage(vehicle)
    rides = vehicle.rides
    return 0 if rides.empty?
  
    total_available_time = calculate_total_available_time(vehicle)
    return 0 if total_available_time.zero?
  
    total_used_time = rides.sum { |ride| (ride.end_time - ride.start_time).to_i }
  
    (total_used_time.to_f / total_available_time) * 100
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


  def time_difference(time_slot)
    start_time, end_time = time_slot
    end_time - start_time if start_time && end_time
  end 

  def calculate_total_used_time(vehicle)
    vehicle.rides.sum { |ride| ride_duration(ride) }
  end

  
  def render_json_success(data, status = :ok)
    render json: { success: true, data: data }, status: status
  end

  def render_json_error(message, status = :unprocessable_entity)
    render json: { success: false, error: message }, status: status
  end

  def render_unauthorized
    render json: { error: 'Not authorized' }, status: :unauthorized
  end
end

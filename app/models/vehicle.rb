class Vehicle < ApplicationRecord
  belongs_to :driver
  has_many :rides

  validates :model, :registration_number, presence: true

  def available?(start_time, end_time)
    overlapping_rides = rides.where('(start_time >= ? AND start_time <= ?) OR (end_time >= ? AND end_time <= ?)', start_time, end_time, start_time, end_time)
    overlapping_rides.empty?
  end

  def available_time_slots
    available_time_slots = []

    if available_time.present?
      available_days = available_time.split(',')
      available_days.each do |day|
        start_time = Time.zone.parse("#{day} 00:00")
        end_time = Time.zone.parse("#{day} 23:59")
        available_time_slots << (start_time..end_time)
      end
    end
    available_time_slots
  end

  def self.create_vehicle(params)
    vehicle = Vehicle.new(params)
    vehicle.save
  end

  def update_vehicle(params)
    update(params)
    self
  end

  def self.destroy_vehicle(vehicle)
    vehicle.destroy
  end
end

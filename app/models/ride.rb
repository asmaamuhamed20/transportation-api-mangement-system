class Ride < ApplicationRecord
  include Geocoding
  
  # Associations
  belongs_to :user
  belongs_to :driver
  belongs_to :vehicle
  belongs_to :coupon, optional: true

  has_many :ride_users
  has_many :users, through: :ride_users, source: :user
  has_many :driver_ride_ratings
  has_many :user_ratings

  has_one :invoice, dependent: :destroy

  # Callbacks
  after_create :generate_invoice
  after_validation :calculate_distance, if: -> { pickup_stop.present? && drop_off_stop.present? }


  # Validations
  validates :user, :driver, :vehicle, presence: true
  validates :pickup_stop, :drop_off_stop, presence: true
  validates :start_time, :end_time, presence: true
  validates :status, presence: true
  validate :end_time_must_be_greater_than_start_time

  # Enum for status
  enum status: { active: 0, completed: 1 }

  before_save :calculate_distance


  # Methods

  def add_user(user)
    users << user unless users.include?(user)
    save
  end  

  def remove_user(user)
    users.delete(user)
  end

  def replace_user(new_user_id)
    new_user = User.find_by(id: new_user_id)

    unless new_user
      return false
    end
    
    self.users.delete_all
    self.users << new_user
    true
  end

  def can_be_rated_by?(user)
    user_id == user&.id
  end

  def build_invoice
    Invoice.new(
      ride_id: self.id,
      user_id: self.user_id,
      driver_id: self.driver_id,
      fare: calculate_fare
    )
  end

  def generate_invoice
    invoice = build_invoice
    unless invoice.save
      logger.error "Failed to generate invoice: #{invoice.errors.full_messages}"
    end
  end

  def vehicle_available?(ride)
    vehicle.available?(ride.start_time, ride.end_time)
  end

  def swap_vehicle(new_vehicle_id)
    swap_vehicle = Vehicle.find_by(id: new_vehicle_id)
    return { status: :not_found } unless swap_vehicle
    if vehicle_available?(self) && update(vehicle: swap_vehicle)
      { status: :ok, message: 'Vehicle swapped successfully', ride: self }
    else
      error_message = vehicle_available?(self) ? errors.full_messages : 'Selected vehicle is not available during this time'
      { status: :unprocessable_entity, message: error_message }
    end
  end

  def complete
    update(status: :completed)
    { status: :ok, message: 'Ride completed successfully', ride: self }
  end

  def save_ride(ride_params)
    ride = Ride.new(ride_params)
    if vehicle_available?(ride)
      if ride.save
        { status: :created, ride: ride, invoice: ride.invoice }
      else
        { status: :unprocessable_entity, errors: ride.errors.full_messages }
      end
    else
      { status: :unprocessable_entity, message: 'Selected vehicle is not available during this time' }
    end
  end


  private

  def end_time_must_be_greater_than_start_time
    errors.add(:end_time, "must be greater than start time") if end_time <= start_time
  end

  def calculate_fare
    return nil if end_time <= start_time

    duration_in_hours = (end_time - start_time) / 3600.0
    fare = duration_in_hours * HOURLY_RATE
    fare.round(2)
  end
end

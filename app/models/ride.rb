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

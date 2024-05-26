class Ride < ApplicationRecord
  attribute :status, :integer, default: 0

  belongs_to :user
  belongs_to :driver
  belongs_to :vehicle

  has_many :ride_users
  has_many :users, through: :ride_users, source: :user
  has_many :driver_ride_ratings
  has_many :user_ratings

  has_one :invoice

  after_create :generate_invoice


  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :user, :driver, :vehicle, presence: true

  enum status: { active: 0, completed: 1 }

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

  private

  def generate_invoice
    invoice = build_invoice
    unless invoice.save
      logger.error "Failed to generate invoice: #{invoice.errors.full_messages}"
    end
  end
  
  def build_invoice
    Invoice.new(
      ride_id: self.id,
      user_id: self.user_id,
      driver_id: self.driver_id,
      fare: calculate_fare
    )
  end
  
  def calculate_fare
    duration_in_hours = (self.end_time - self.start_time) / 3600.0
    fare = duration_in_hours * HOURLY_RATE
  end
end

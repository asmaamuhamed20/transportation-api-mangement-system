class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  has_many :rides
  has_many :driver_ride_ratings
  has_many :invoices

  def admin?
    role == 'admin'
  end

  def self.create_user(user_params)
    user = User.new(user_params)
    if user.save
      { status: :created, user: user }
    else
      { status: :unprocessable_entity, errors: user.errors.full_messages }
    end
  end

  def update_user(user_params)
    if update(user_params)
      { status: :ok, user: self }
    else
      { status: :unprocessable_entity, errors: errors.full_messages }
    end
  end

  def destroy_user
    if rides.destroy_all && driver_ride_ratings.destroy_all && destroy
      { status: :ok, message: "User and associated resources deleted successfully" }
    else
      { status: :unprocessable_entity, message: "Failed to delete user and associated resources" }
    end
  end

  def self.rides_for_date(user, date)
    if user.admin?
      Ride.where('DATE(start_time) = ?', date).includes(:driver, :vehicle).order(start_time: :desc)
    else
      user.rides.where('DATE(start_time) = ?', date).includes(:driver, :vehicle).order(start_time: :desc)
    end
  end
end

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true
  has_many :rides
  has_many :driver_ride_ratings

  def admin?
    role == 'admin'
  end
end

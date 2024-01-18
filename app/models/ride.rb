class Ride < ApplicationRecord
  belongs_to :user
  belongs_to :driver
  belongs_to :vehicle

  has_many :ride_users
  has_many :selected_users, through: :ride_users, source: :user

  validates :start_time, presence: true
  validates :end_time, presence: true
end

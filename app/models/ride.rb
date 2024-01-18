class Ride < ApplicationRecord
  belongs_to :user
  belongs_to :driver
  belongs_to :vehicle

  

  validates :start_time, presence: true
  validates :end_time, presence: true
end

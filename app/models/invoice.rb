class Invoice < ApplicationRecord
  belongs_to :ride
  belongs_to :user
  belongs_to :driver

  validates :ride_id, :user_id, :driver_id, :fare, presence: true
end

class Invoice < ApplicationRecord
  belongs_to :ride
  has_many :driver_payments

  validates :ride_id, presence: true

  def self.user_invoices(user)
    joins(:ride).where(rides: { user_id: user.id })
  end

  def self.all_invoices
    all.includes(ride: [:user, :driver])
  end
end

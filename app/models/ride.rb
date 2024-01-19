class Ride < ApplicationRecord
  belongs_to :user
  belongs_to :driver
  belongs_to :vehicle

  has_many :ride_users
  has_many :users, through: :ride_users, source: :user

  validates :start_time, presence: true
  validates :end_time, presence: true

  def add_user(user)
    users << user unless users.include?(user)
  end  

  def remove_user(user)
    users.delete(user)
  end

  def replace_user(new_user)
    update(user_id: new_user.id)
  end
end

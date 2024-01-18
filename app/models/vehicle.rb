class Vehicle < ApplicationRecord
  belongs_to :driver
  has_many :rides

  # check if ther is an overlapping rides
  def available?(start_time, end_time)
    rides.where('(start_time >= ? AND start_time <= ?) OR (end_time >= ? AND end_time <= ?)', start_time, end_time, start_time, end_time).empty?
  end
end

class DriverPayment < ApplicationRecord
  belongs_to :driver
  belongs_to :invoice
end

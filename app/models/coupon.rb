class Coupon < ApplicationRecord
    belongs_to :user, optional: true
end

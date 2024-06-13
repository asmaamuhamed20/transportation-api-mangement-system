class Coupon < ApplicationRecord
    belongs_to :user, optional: true
    has_many :rides

    before_create :set_default_applied
  
    validates :code, presence: true, uniqueness: true
    validates :distance_threshold, numericality: { greater_than_or_equal_to: 0 }, allow_nil: false
    validates :applied, inclusion: { in: [true, false] }
  
    def apply_to_ride(ride)
        return false unless valid_for_ride?(ride)
        return false if ride.coupon.present?
    
        transaction do
          ride.update!(coupon: self)
          increment!(:usage_count)
          update!(applied: true) 
          update_invoice(ride)
        end
    end
    
    def expired?
        expiry_date < Date.today
    end
    
    def usage_limit_reached?
        usage_count >= usage_limit
    end
    
    private
    
    def valid_for_ride?(ride)
        ride.distance <= distance_threshold && !expired? && !usage_limit_reached?
    end
    
    def update_invoice(ride)
        invoice = ride.invoice || ride.build_invoice
        discount_percentage = discount_amount.to_f
        
        # Calculate discounted fare
        original_fare = invoice.fare.to_f
        discounted_amount = ((discount_percentage / 100) * original_fare).round(2)
        discounted_fare = (original_fare - discounted_amount).round(2)

        # Update invoice with discounted values
        invoice.update!(discount: discounted_amount, fare: discounted_fare)
    end
    
    def set_default_applied
        self.applied ||= false
    end
end

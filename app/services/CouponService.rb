class CouponService
  ERROR_MESSAGES = {
    not_found: 'Ride or Coupon not found',
    already_applied: 'Coupon has already been applied to this ride',
    expired: 'Coupon is expired',
    usage_limit_reached: 'Coupon has reached its usage limit',
    unauthorized: 'Unauthorized to apply coupon to this ride',
    apply_error: 'Coupon could not be applied'
  }.freeze

  def initialize(params, current_user)
    @params = params
    @current_user = current_user
  end

  def apply_coupon
    ride = Ride.find_by(id: @params[:ride_id])
    coupon = Coupon.find_by(code: @params[:coupon_code])

 
    return error_response(:not_found) unless ride && coupon
    return error_response(:already_applied) if ride.coupon.present?
    return error_response(:expired) if coupon.expired?
    return error_response(:usage_limit_reached) if coupon.usage_limit_reached?
    return error_response(:unauthorized) unless authorized?(ride)

    result = coupon.apply_to_ride(ride)
    return error_response(:apply_error) unless result[:success]

    { success: true, data: { message: result[:message], invoice: result[:invoice] } }
  end

  private

  def authorized?(ride)
    ride.user == @current_user
  end

  def error_response(key)
    { success: false, error: { key => ERROR_MESSAGES[key] } }
  end
end
  
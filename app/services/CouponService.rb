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

    error_key = determine_error_key(ride, coupon)
    return error_response(error_key) if error_key

    if coupon.apply_to_ride(ride)
      { success: true, data: { message: 'Coupon applied successfully', invoice: ride.invoice } }
    else
      error_response(:apply_error)
    end
  end

  private

  def determine_error_key(ride, coupon)
    return :not_found unless ride && coupon
    return :already_applied if ride.coupon.present?
    return :expired if coupon.expired?
    return :usage_limit_reached if coupon.usage_limit_reached?
    return :unauthorized unless authorized?(ride)
  end

  def authorized?(ride)
    ride.user == @current_user
  end

  def error_response(key)
    { success: false, error: { key => ERROR_MESSAGES[key] } }
  end
end
  
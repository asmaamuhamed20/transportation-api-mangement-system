class Api::V1::CouponsController < ApplicationController
    before_action :set_coupon, only: [:show, :update, :destroy]
    before_action :authenticate_request!


    # GET /api/v1/coupons
    def index
        render json: Coupon.all
    end

    # GET /api/v1/coupons/:id
    def show
        render json: @coupon
    end

    # POST /api/v1/coupons
    def create
        @coupon = Coupon.new(coupon_params)

        if @coupon.save
          render_json_success(@coupon, :created)
        else
          render_json_error(@coupon.errors.full_messages.join(", "))
        end
    end

    # PUT /api/v1/coupons/1
    def update
        if @coupon.update(coupon_params)
            render_json_success(@coupon)
        else
            render_json_error(@coupon.errors.full_messages.join(", "))
        end
    end

    # DELETE /api/v1/coupons/1
    def destroy
        if @coupon.destroy
            render_json_success('Coupon deleted successfully')
        else
            render_error(:unprocessable_entity, 'Failed to delete coupon')
        end  
    end

  # POST /api/v1/coupons/apply
    def apply
        coupon_service = CouponService.new(params, @current_user)
        result = coupon_service.apply_coupon
    
        if result[:success]
            invoice = result[:data][:invoice]
            render_json_success({ message: "Coupon applied successfully", invoice: invoice }, :ok)
        else
            render_json_error(result[:error][:apply_error], :unprocessable_entity)
        end
    end
      

    private 


    def set_coupon
        @coupon = Coupon.find(params[:id])
    end

    def coupon_params
        params.require(:coupon).permit(:code, :discount_amount, :expiry_date, :usage_limit, :usage_count, :distance_threshold)
    end

    def render_json_success(data, status = :ok)
        render json: { success: true, data: data }, status: status
    end
  
    def render_json_error(message, status = :unprocessable_entity)
        render json: { success: false, error: message }, status: status
    end
end

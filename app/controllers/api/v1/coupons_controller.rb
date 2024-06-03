class Api::V1::CouponsController < ApplicationController
    before_action :set_coupon, only: [:show, :update, :destroy]

    def index
        render json: Coupon.all
    end

    def show
        render json: @coupon
    end

    def create
        @coupon = Coupon.new(coupon_params)

        if @coupon.save
          render_json_success(@coupon, :created)
        else
          render_json_error(@coupon.errors.full_messages.join(", "))
        end
    end

    def update
        if @coupon.update(coupon_params)
            render_json_success(@coupon)
        else
            render_json_error(@coupon.errors.full_messages.join(", "))
        end
    end

    def destroy
        if @coupon.destroy
            render_json_success('Coupon deleted successfully')
        else
            render_error(:unprocessable_entity, 'Failed to delete coupon')
        end  
    end

    private 


    def set_coupon
        @coupon = Coupon.find(params[:id])
    end

    def coupon_params
        params.require(:coupon).permit(:code, :discount_amount, :expiry_date, :usage_limit, :usage_count)
    end

    def render_json_success(data, status = :ok)
        render json: { success: true, data: data }, status: status
    end
  
    def render_json_error(message, status = :unprocessable_entity)
        render json: { success: false, error: message }, status: status
    end
end

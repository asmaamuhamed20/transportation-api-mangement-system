class Api::V1::DriverPaymentsController < ApplicationController
    before_action :find_invoice_and_driver, only: [:create]
    before_action :find_driver, only: [:driver_payments_history]

    # POST: /api/v1/driver_payments
    def create
        return unless @invoice && @driver

        payment_amount = calculate_driver_payment(@invoice.fare)
        driver_payment = build_driver_payment(payment_amount)
    
        if driver_payment.save
          render_json_success('Payment recorded successfully', driver_payment: driver_payment)
        else
          render_error(:unprocessable_entity, driver_payment.errors.full_messages)
        end
    end

    # GET: /api/v1/driver_payments/driver_payments_history/:driver_id
    def driver_payments_history
        @payments = @driver.driver_payments
        render_json_success('Payments listed successfully', @payments)
    end

    private

    def find_invoice_and_driver
        @invoice = Invoice.find_by(id: params[:invoice_id])
        @driver = @invoice&.driver
        render_error(:not_found, "Invoice or Driver not found for Invoice ID #{params[:invoice_id]}") unless @invoice && @driver
    end
    
    def find_driver
        @driver = Driver.find_by(id: params[:driver_id])
        render_error(:not_found, "Driver with ID #{params[:driver_id]} not found") unless @driver
    end


    def calculate_driver_payment(fare)
        (fare.to_d * 0.45).round(2)
    end

    def build_driver_payment(payment_amount)
        @driver.driver_payments.build(payment_amount: payment_amount, invoice: @invoice)
    end

    def render_invoice_not_found_error
        render_error(:not_found, "Invoice with ID #{params[:invoice_id]} not found")
    end
    
    def render_driver_not_found_error
        render_error(:not_found, "Driver not found for invoice with ID #{@invoice.id}")
    end

    def render_error(status, messages)
        render json: { error: messages }, status: status
    end

    def render_json_success(message, data = {})
        render json: { success: true, message: message, data: data }, status: :ok
    end
end

class Api::V1::DriverPaymentsController < ApplicationController
    before_action :find_invoice_and_driver, only: [:create]
    before_action :find_driver, only: [:driver_payments_history]

    # POST: /api/v1/driver_payments
    def create
        result = DriverPayment.create_payment(@invoice)
        if result[:success]
            render_json_success('Payment recorded successfully', driver_payment: result[:driver_payment])
        else
            render_error(:unprocessable_entity, result[:error])
        end
    end

    # GET: /api/v1/driver_payments/driver_payments_history/:driver_id
    def driver_payments_history
        result = DriverPayment.payments_for_driver(params[:driver_id])
        if result[:success]
          render_json_success('Payments listed successfully', payments: result[:payments])
        else
          render_error(:not_found, result[:error])
        end
    end

    private

    def find_invoice_and_driver
        @invoice = Invoice.find_by(id: params[:invoice_id])
        render_error(:not_found, "Invoice with ID #{params[:invoice_id]} not found") unless @invoice
    end
    
    def find_driver
        @driver = Driver.find_by(id: params[:driver_id])
        render_error(:not_found, "Driver with ID #{params[:driver_id]} not found") unless @driver
    end

    def render_error(status, messages)
        render json: { error: messages }, status: status
    end

    def render_json_success(message, data = {})
        render json: { success: true, message: message, data: data }, status: :ok
    end
end

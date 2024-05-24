class Api::V1::InvoicesController < ApplicationController
    before_action :find_user, only: [:user_invoices_history]
    before_action :find_driver, only: [:driver_invoices_history]

    def list_all_invoices
        render json: Invoice.all 
    end

    def user_invoices_history
        if @user
            @invoices = @user.invoices
            render_invoices(@invoices)  
        else
            render_error(:not_found, "User with ID #{params[:user_id]} not found")
        end 
    end

    def driver_invoices_history
        if @driver
            @invoices = @driver.invoices
            render_invoices(@invoices)        
        else
            render_error(:not_found, "Driver with ID #{params[:driver_id]} not found")
        end    
    end


    private

    def find_user
        @user = User.find(params[:user_id])
    end

    def find_driver
        @driver = Driver.find(params[:driver_id])
    end

    def render_error(status, messages)
        render json: { error: messages }, status: status
    end
    
    def render_json_success(message, data = {})
        render json: { success: true, message: message, data: data }, status: :ok
    end

    def render_invoices(invoices, success_message = 'Invoices listed successfully')
        if invoices.present?
          render_json_success(success_message, invoices)
        else
          render_error(:not_found, 'No invoices found')
        end
    end
end
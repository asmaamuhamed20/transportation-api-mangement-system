class Api::V1::InvoicesController < ApplicationController
    before_action :find_user, only: [:user_invoices_history]

    # GET: /api/v1/invoices/list_all_invoices
    def list_all_invoices
        render_json_success(Invoice.all_invoices)
    end

    # GET: /api/v1/invoices/user_invoices_history/:user_id
    def user_invoices_history
        if @user
            @invoices = @user.invoices
            render_invoices(@invoices)  
        else
            render_error(:not_found, "User with ID #{params[:user_id]} not found")
        end 
    end

    private

    def find_user
        @user = User.find(params[:user_id])
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

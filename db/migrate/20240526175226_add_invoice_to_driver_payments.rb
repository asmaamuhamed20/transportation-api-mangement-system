class AddInvoiceToDriverPayments < ActiveRecord::Migration[7.1]
  def change
    add_reference :driver_payments, :invoice, null: false, foreign_key: true
  end
end

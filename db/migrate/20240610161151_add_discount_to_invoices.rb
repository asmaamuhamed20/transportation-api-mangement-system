class AddDiscountToInvoices < ActiveRecord::Migration[7.1]
  def change
    add_column :invoices, :discount, :decimal
  end
end

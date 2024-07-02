class RemoveUserIdAndDriverIdFromInvoices < ActiveRecord::Migration[7.1]
  def change
    remove_column :invoices, :user_id, :integer
    remove_column :invoices, :driver_id, :integer
  end
end

class SetRideInvoicesStatusToPending < ActiveRecord::Migration[7.1]
  def change
    change_column_default :invoices, :status, from: nil, to: 'Pending'
  end

  def up
    Invoice.where(status: nil).update_all(status: 'Pending')
  end
end

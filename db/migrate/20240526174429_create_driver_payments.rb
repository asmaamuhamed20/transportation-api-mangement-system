class CreateDriverPayments < ActiveRecord::Migration[7.1]
  def change
    create_table :driver_payments do |t|
      t.references :driver, null: false, foreign_key: true
      t.decimal :payment_amount

      t.timestamps
    end
  end
end

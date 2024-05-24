class CreateInvoices < ActiveRecord::Migration[7.1]
  def change
    create_table :invoices do |t|
      t.references :ride, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.decimal :fare
      t.string :status


      t.timestamps
    end
  end
end

class CreateCoupons < ActiveRecord::Migration[7.1]
  def change
    create_table :coupons do |t|
      t.string :code
      t.decimal :discount_amount
      t.date :expiry_date
      t.integer :usage_limit
      t.integer :usage_count

      t.timestamps
    end
  end
end

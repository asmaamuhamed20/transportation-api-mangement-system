class CreateVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :vehicles do |t|
      t.string :model
      t.string :registration_number
      t.references :driver, null: false, foreign_key: true
      t.string :available_time

      t.timestamps
    end
  end
end

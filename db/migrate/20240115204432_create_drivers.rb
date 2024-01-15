class CreateDrivers < ActiveRecord::Migration[7.1]
  def change
    create_table :drivers do |t|
      t.string :driver_name

      t.timestamps
    end
  end
end

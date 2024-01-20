class CreateRides < ActiveRecord::Migration[7.1]
  def change
    create_table :rides do |t|
      t.references :user, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.references :vehicle, null: false, foreign_key: true
      t.string :pickup_stop
      t.string :drop_off_stop
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end

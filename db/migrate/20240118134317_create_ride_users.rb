class CreateRideUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :ride_users do |t|
      t.references :ride, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

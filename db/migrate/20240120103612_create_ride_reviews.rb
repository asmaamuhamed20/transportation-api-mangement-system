class CreateRideReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :ride_reviews do |t|
      t.references :ride, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :rating
      t.text :comment

      t.timestamps
    end
  end
end

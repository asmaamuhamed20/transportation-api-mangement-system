class CreateRatings < ActiveRecord::Migration[7.1]
  def change
    create_table :ratings do |t|
      t.references :ride, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :driver, null: false, foreign_key: true
      t.integer :rating_value
      t.text :comment

      t.timestamps
    end
  end
end

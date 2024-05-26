class ModifyForeignKeys < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key "driver_ride_ratings", "rides", on_delete: :cascade
    remove_foreign_key "invoices", "rides"
    add_foreign_key "invoices", "rides", on_delete: :cascade
    remove_foreign_key "user_ratings", "rides"
    add_foreign_key "user_ratings", "rides", on_delete: :cascade
  end
end

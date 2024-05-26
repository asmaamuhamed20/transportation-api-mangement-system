class AddCascadeDeleteToForeignKeys < ActiveRecord::Migration[7.1]
  def change
    remove_foreign_key "driver_ride_ratings", "drivers"
    add_foreign_key "driver_ride_ratings", "drivers", on_delete: :cascade

    remove_foreign_key "invoices", "drivers"
    add_foreign_key "invoices", "drivers", on_delete: :cascade

    add_foreign_key "ride_users", "users", on_delete: :cascade

    remove_foreign_key "user_ratings", "rides"
    add_foreign_key "user_ratings", "rides", on_delete: :cascade

    remove_foreign_key "user_ratings", "users"
    add_foreign_key "user_ratings", "users", on_delete: :cascade
  end
end

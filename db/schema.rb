# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_20_102259) do
  create_table "drivers", force: :cascade do |t|
    t.string "driver_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ratings", force: :cascade do |t|
    t.integer "ride_id", null: false
    t.integer "user_id", null: false
    t.integer "driver_id", null: false
    t.integer "rating_value"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_ratings_on_driver_id"
    t.index ["ride_id"], name: "index_ratings_on_ride_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "ride_users", force: :cascade do |t|
    t.integer "ride_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ride_id"], name: "index_ride_users_on_ride_id"
    t.index ["user_id"], name: "index_ride_users_on_user_id"
  end

  create_table "rides", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "driver_id", null: false
    t.integer "vehicle_id", null: false
    t.string "pickup_stop"
    t.string "drop_off_stop"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0
    t.index ["driver_id"], name: "index_rides_on_driver_id"
    t.index ["user_id"], name: "index_rides_on_user_id"
    t.index ["vehicle_id"], name: "index_rides_on_vehicle_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "roles"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vehicles", force: :cascade do |t|
    t.string "model"
    t.string "registration_number"
    t.integer "driver_id", null: false
    t.string "available_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_id"], name: "index_vehicles_on_driver_id"
  end

  add_foreign_key "ratings", "drivers"
  add_foreign_key "ratings", "rides"
  add_foreign_key "ratings", "users"
  add_foreign_key "ride_users", "rides"
  add_foreign_key "ride_users", "users"
  add_foreign_key "rides", "drivers"
  add_foreign_key "rides", "users"
  add_foreign_key "rides", "vehicles"
  add_foreign_key "vehicles", "drivers"
end

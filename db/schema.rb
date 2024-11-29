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

ActiveRecord::Schema[7.0].define(version: 2024_11_29_015840) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admins", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "username"
    t.string "password_digest"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "arrivals", force: :cascade do |t|
    t.string "name"
    t.bigint "place_id"
    t.bigint "trip_id"
    t.integer "order_place"
    t.datetime "end_time_est"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["place_id"], name: "index_arrivals_on_place_id"
    t.index ["trip_id"], name: "index_arrivals_on_trip_id"
  end

  create_table "blacklisted_tokens", force: :cascade do |t|
    t.uuid "uuid"
    t.string "type"
    t.datetime "revoked_at"
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_blacklisted_tokens_on_token", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "full_name"
    t.string "email"
    t.string "phone"
    t.string "avatar_link"
    t.string "username"
    t.string "password_digest"
    t.integer "amount_invite"
    t.string "invite_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "driver_balance_transactions", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "driver_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "balance_after", precision: 10, scale: 2
    t.integer "transaction_type"
    t.integer "transaction_status"
    t.bigint "approved_by_id"
    t.datetime "approved_at"
    t.datetime "requested_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_driver_balance_transactions_on_approved_by_id"
    t.index ["driver_id"], name: "index_driver_balance_transactions_on_driver_id"
  end

  create_table "drivers", force: :cascade do |t|
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.string "full_name"
    t.string "email"
    t.string "phone"
    t.string "avatar_link"
    t.string "front_side_link"
    t.string "backside_link"
    t.string "id_number"
    t.string "username"
    t.string "password_digest"
    t.decimal "balance"
    t.boolean "is_available"
    t.float "rating_avg"
    t.integer "amount_invite"
    t.string "invite_code"
    t.integer "status", default: 0
    t.datetime "kyc_at"
    t.bigint "kyc_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "kyc_review"
    t.index ["kyc_by_id"], name: "index_drivers_on_kyc_by_id"
  end

  create_table "invited_friends", force: :cascade do |t|
    t.uuid "to_uuid", null: false
    t.uuid "from_uuid", null: false
    t.string "invite_code", null: false
    t.integer "invite_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.bigint "trip_id", null: false
    t.decimal "amount", precision: 10, scale: 2
    t.integer "method", default: 0
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trip_id"], name: "index_payments_on_trip_id"
    t.index ["uuid"], name: "index_payments_on_uuid"
  end

  create_table "place_expenses", force: :cascade do |t|
    t.bigint "from_place_id", null: false
    t.bigint "to_place_id", null: false
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "time_of_expense"
    t.index ["from_place_id"], name: "index_place_expenses_on_from_place_id"
    t.index ["to_place_id"], name: "index_place_expenses_on_to_place_id"
  end

  create_table "places", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "refresh_tokens", force: :cascade do |t|
    t.string "crypted_token"
    t.uuid "uuid"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crypted_token"], name: "index_refresh_tokens_on_crypted_token", unique: true
  end

  create_table "trips", force: :cascade do |t|
    t.uuid "uuid", default: -> { "gen_random_uuid()" }, null: false
    t.string "fight_no"
    t.bigint "driver_id"
    t.bigint "customer_id"
    t.bigint "depart_place_id"
    t.datetime "booking_time"
    t.integer "seat"
    t.datetime "start_time_est"
    t.datetime "start_time_real"
    t.integer "trip_status", default: 0
    t.integer "rating"
    t.decimal "total_price"
    t.decimal "est_price"
    t.decimal "fee"
    t.float "fee_rate"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "end_time_real"
    t.index ["booking_time"], name: "index_trips_on_booking_time"
    t.index ["customer_id"], name: "index_trips_on_customer_id"
    t.index ["depart_place_id"], name: "index_trips_on_depart_place_id"
    t.index ["driver_id"], name: "index_trips_on_driver_id"
    t.index ["fight_no"], name: "index_trips_on_fight_no", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "arrivals", "places"
  add_foreign_key "arrivals", "trips"
  add_foreign_key "driver_balance_transactions", "admins", column: "approved_by_id"
  add_foreign_key "driver_balance_transactions", "drivers"
  add_foreign_key "drivers", "admins", column: "kyc_by_id"
  add_foreign_key "payments", "trips"
  add_foreign_key "place_expenses", "places", column: "from_place_id"
  add_foreign_key "place_expenses", "places", column: "to_place_id"
  add_foreign_key "trips", "customers"
  add_foreign_key "trips", "drivers"
  add_foreign_key "trips", "places", column: "depart_place_id"
end

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_25_121211) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "banners", force: :cascade do |t|
    t.string "name"
    t.string "link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "baskets", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "count"
    t.integer "agent_id"
    t.bigint "client_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agent_id"], name: "index_baskets_on_agent_id"
    t.index ["client_id"], name: "index_baskets_on_client_id"
    t.index ["product_id"], name: "index_baskets_on_product_id"
  end

  create_table "blogs", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "client_bonus", force: :cascade do |t|
    t.integer "current"
    t.integer "added_bonus"
    t.bigint "client_id", null: false
    t.integer "bonus"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_client_bonus_on_client_id"
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "city"
    t.string "phone", default: [], array: true
    t.datetime "date_of_birth"
    t.string "client_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_clients_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "social_media"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "districts", force: :cascade do |t|
    t.string "name"
    t.integer "clients", default: [], array: true
    t.bigint "provider_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider_id"], name: "index_districts_on_provider_id"
  end

  create_table "instuctions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.bigint "shop_id", null: false
    t.string "payment_type"
    t.float "used_bonus"
    t.boolean "status", default: false
    t.bigint "provider_id", null: false
    t.bigint "waybill_id"
    t.integer "agent_id"
    t.float "tonnage"
    t.boolean "accept_by_client"
    t.boolean "accept_by_provider"
    t.datetime "canceled_by_client"
    t.datetime "canceled_by_provider"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agent_id"], name: "index_invoices_on_agent_id"
    t.index ["client_id"], name: "index_invoices_on_client_id"
    t.index ["provider_id"], name: "index_invoices_on_provider_id"
    t.index ["shop_id"], name: "index_invoices_on_shop_id"
    t.index ["waybill_id"], name: "index_invoices_on_waybill_id"
  end

  create_table "jwt_blacklist", id: :serial, force: :cascade do |t|
    t.string "jti", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "client_id", null: false
    t.bigint "provider_id", null: false
    t.string "payment_type"
    t.float "used_bonus"
    t.text "wishes"
    t.datetime "arrival_at"
    t.string "status"
    t.float "total"
    t.integer "count"
    t.bigint "shop_id", null: false
    t.bigint "invoice_id"
    t.integer "agent_id"
    t.float "tonnage"
    t.boolean "accept_by_client"
    t.boolean "accept_by_provider"
    t.datetime "canceled_by_client"
    t.datetime "canceled_by_provider"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["agent_id"], name: "index_orders_on_agent_id"
    t.index ["client_id"], name: "index_orders_on_client_id"
    t.index ["invoice_id"], name: "index_orders_on_invoice_id"
    t.index ["product_id"], name: "index_orders_on_product_id"
    t.index ["provider_id"], name: "index_orders_on_provider_id"
    t.index ["shop_id"], name: "index_orders_on_shop_id"
  end

  create_table "product_reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "body"
    t.json "liked_users"
    t.json "disliked_users"
    t.uuid "product", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_product_reviews_on_user_id"
  end

  create_table "products", force: :cascade do |t|
    t.uuid "uuid"
    t.string "name"
    t.text "description"
    t.bigint "subcategory_id", null: false
    t.bigint "provider_id", null: false
    t.json "characteristics"
    t.float "retail_price"
    t.float "wholesale_price"
    t.float "retail_price_with_discount"
    t.float "wholesale_price_with_discount"
    t.decimal "rate", default: "0.0"
    t.boolean "bestseller", default: false
    t.boolean "novelty", default: false
    t.string "status", default: "active"
    t.json "buy_with"
    t.float "retail_discount", default: 0.0
    t.float "wholesale_discount", default: 0.0
    t.integer "pack", default: 0
    t.float "wight", default: 0.0
    t.integer "clients_favorites", default: [], array: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider_id"], name: "index_products_on_provider_id"
    t.index ["subcategory_id"], name: "index_products_on_subcategory_id"
  end

  create_table "provider_bonus", force: :cascade do |t|
    t.bigint "provider_id", null: false
    t.float "intent"
    t.integer "bonus"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider_id"], name: "index_provider_bonus_on_provider_id"
  end

  create_table "provider_reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "body"
    t.json "liked_users"
    t.json "disliked_users"
    t.bigint "provider_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provider_id"], name: "index_provider_reviews_on_provider_id"
    t.index ["user_id"], name: "index_provider_reviews_on_user_id"
  end

  create_table "providers", force: :cascade do |t|
    t.string "name"
    t.json "address"
    t.string "phone"
    t.text "description"
    t.string "status", default: "active"
    t.string "min_amount"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_providers_on_user_id"
  end

  create_table "shops", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "name"
    t.json "address"
    t.string "type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_shops_on_client_id"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "role"
    t.bigint "provider_id", null: false
    t.bigint "user_id", null: false
    t.bigint "district_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["district_id"], name: "index_staffs_on_district_id"
    t.index ["provider_id"], name: "index_staffs_on_provider_id"
    t.index ["user_id"], name: "index_staffs_on_user_id"
  end

  create_table "subcategories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "category_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "name"
    t.string "phone"
    t.string "role"
    t.boolean "blocked", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "waybills", force: :cascade do |t|
    t.boolean "status", default: false
    t.integer "number"
    t.bigint "provider_id", null: false
    t.integer "manager_id"
    t.integer "deliveryman_id"
    t.integer "invoices", default: [], array: true
    t.float "tonnage"
    t.datetime "begin_time"
    t.datetime "end_time"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["deliveryman_id"], name: "index_waybills_on_deliveryman_id"
    t.index ["manager_id"], name: "index_waybills_on_manager_id"
    t.index ["provider_id"], name: "index_waybills_on_provider_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "baskets", "clients"
  add_foreign_key "baskets", "products"
  add_foreign_key "baskets", "staffs", column: "agent_id"
  add_foreign_key "client_bonus", "clients"
  add_foreign_key "clients", "users"
  add_foreign_key "districts", "providers"
  add_foreign_key "invoices", "clients"
  add_foreign_key "invoices", "providers"
  add_foreign_key "invoices", "shops"
  add_foreign_key "invoices", "staffs", column: "agent_id"
  add_foreign_key "invoices", "waybills"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "invoices"
  add_foreign_key "orders", "products"
  add_foreign_key "orders", "providers"
  add_foreign_key "orders", "shops"
  add_foreign_key "orders", "staffs", column: "agent_id"
  add_foreign_key "product_reviews", "users"
  add_foreign_key "products", "providers"
  add_foreign_key "products", "subcategories"
  add_foreign_key "provider_bonus", "providers"
  add_foreign_key "provider_reviews", "providers"
  add_foreign_key "provider_reviews", "users"
  add_foreign_key "providers", "users"
  add_foreign_key "shops", "clients"
  add_foreign_key "staffs", "districts"
  add_foreign_key "staffs", "providers"
  add_foreign_key "staffs", "users"
  add_foreign_key "subcategories", "categories"
  add_foreign_key "waybills", "providers"
  add_foreign_key "waybills", "staffs", column: "deliveryman_id"
  add_foreign_key "waybills", "staffs", column: "manager_id"
end

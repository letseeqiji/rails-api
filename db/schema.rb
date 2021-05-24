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

ActiveRecord::Schema.define(version: 2021_05_23_150554) do

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "user_id", default: 0, null: false
    t.integer "price_total", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "placements", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "order_id", default: 0, null: false
    t.integer "product_id", default: 0, null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id", "product_id"], name: "index_placements_on_order_id_and_product_id"
    t.index ["product_id", "order_id"], name: "index_placements_on_product_id_and_order_id"
  end

  create_table "products", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "title", default: "", null: false
    t.integer "price", default: 0, null: false
    t.integer "published", default: 1, null: false
    t.integer "shop_id", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "quantity", default: 0, null: false
    t.index ["shop_id", "title"], name: "index_products_on_shop_id_and_title"
    t.index ["title"], name: "index_products_on_title"
  end

  create_table "shops", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.integer "products_count", default: 0, null: false
    t.integer "orders_count", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "user_id", default: 0, null: false
    t.index ["name"], name: "index_shops_on_name"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "email", limit: 100, default: "", null: false
    t.string "password_digest", limit: 256, default: "", null: false
    t.integer "role", default: 1, null: false, unsigned: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end

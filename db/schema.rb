# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_04_015903) do

  create_table "carts", force: :cascade do |t|
    t.integer "item_id"
    t.integer "user_id"
    t.integer "count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "payment_id"
<<<<<<< HEAD
    t.boolean "completed", default: false
=======
    t.boolean "completed"
>>>>>>> 08121428cb7e04e50884c4f3135901651d26aae6
    t.index ["item_id"], name: "index_carts_on_item_id"
    t.index ["payment_id"], name: "index_carts_on_payment_id"
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "charges", force: :cascade do |t|
    t.integer "stored_value"
    t.integer "card_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["card_id"], name: "index_charges_on_card_id"
    t.index ["user_id"], name: "index_charges_on_user_id"
  end

  create_table "credits", force: :cascade do |t|
    t.integer "column_name"
    t.integer "credit_number"
    t.string "security_number"
    t.string "expiration_date"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_credits_on_user_id"
  end

  create_table "items", force: :cascade do |t|
    t.integer "shop_id"
    t.string "name"
    t.integer "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_items_on_shop_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer "total"
    t.boolean "completed", default: false
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "shops", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_payments", force: :cascade do |t|
    t.integer "user_id"
    t.integer "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_id"], name: "index_user_payments_on_payment_id"
    t.index ["user_id"], name: "index_user_payments_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.boolean "is_owner", default: false
    t.integer "balance", default: 0
    t.string "email"
    t.integer "shop_id"
    t.string "name"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shop_id"], name: "index_users_on_shop_id"
  end

end

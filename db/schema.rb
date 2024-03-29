# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160312223658) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ebay_items", id: :bigserial, force: :cascade do |t|
    t.string   "name"
    t.datetime "ends_at"
    t.integer  "bid_price_cents"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "number_of_bids",  default: 0, null: false
    t.string   "img"
  end

  create_table "snipes", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "ebay_item_id",     limit: 8
    t.integer  "max_amount_cents"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "snipes", ["user_id", "ebay_item_id"], name: "index_snipes_on_user_id_and_ebay_item_id", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.jsonb    "ebay_login_data"
  end

  add_foreign_key "snipes", "ebay_items"
  add_foreign_key "snipes", "users"
end

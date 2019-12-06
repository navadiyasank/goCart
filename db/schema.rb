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

ActiveRecord::Schema.define(version: 2019_11_30_155322) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", default: true
    t.string "icon_type", default: "cart"
    t.string "icon_color", default: "#000000"
    t.string "icon_shape", default: "circle"
    t.float "blink_speed", default: 1.5
    t.string "blink_color", default: "rgba(255, 255, 255, 0.4)"
    t.string "blink_wider", default: "10px"
    t.string "cart_title_text", default: "{cart_items} items missing"
    t.string "no_cart_title_text", default: "⚡️ Secret Sale ⚡️ Save 20% Off"
    t.string "title_animation_type", default: "blink"
    t.boolean "is_paid"
    t.boolean "is_advance"
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

end

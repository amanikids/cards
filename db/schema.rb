# This file is auto-generated from the current state of the database. Instead of editing this file,
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20081010120208) do

  create_table "items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "variant_id"
    t.integer  "quantity",   :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password", :limit => 40
    t.string   "remember_me_token",  :limit => 40
    t.string   "salt",               :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variants", :force => true do |t|
    t.integer  "product_id"
    t.string   "name"
    t.integer  "cents"
    t.string   "currency",   :default => "USD"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

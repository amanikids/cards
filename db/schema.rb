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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101021133044) do

  create_table "carts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "cart_id",    :null => false
    t.integer  "product_id", :null => false
    t.integer  "quantity",   :null => false
    t.integer  "unit_price", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.integer  "cart_id",      :null => false
    t.integer  "payment_id",   :null => false
    t.string   "payment_type", :null => false
    t.string   "token",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "orders", ["token"], :name => "index_orders_on_token", :unique => true

  create_table "paypal_accounts", :force => true do |t|
    t.string   "login",      :null => false
    t.string   "password",   :null => false
    t.string   "signature",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "paypal_payments", :force => true do |t|
    t.string   "payer_id",   :null => false
    t.string   "token",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "price",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["name"], :name => "index_products_on_name", :unique => true

  create_table "stores", :force => true do |t|
    t.string   "name",              :null => false
    t.string   "slug",              :null => false
    t.string   "currency",          :null => false
    t.integer  "paypal_account_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stores", ["slug"], :name => "index_stores_on_slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                   :null => false
    t.string   "password_hash",           :null => false
    t.string   "password_salt",           :null => false
    t.string   "password_recovery_token", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["password_recovery_token"], :name => "index_users_on_password_recovery_token", :unique => true

end

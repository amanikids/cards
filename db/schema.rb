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

ActiveRecord::Schema.define(:version => 20101104131908) do

  create_table "addresses", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "line_1",     :null => false
    t.string   "line_2",     :null => false
    t.string   "line_3"
    t.string   "line_4"
    t.string   "country",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "administrators", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "carts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_id",   :null => false
  end

  add_index "carts", ["store_id"], :name => "index_carts_on_store_id"

  create_table "items", :force => true do |t|
    t.integer  "cart_id",                     :null => false
    t.integer  "quantity",     :default => 1, :null => false
    t.integer  "unit_price",                  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "packaging_id",                :null => false
  end

  create_table "justgiving_accounts", :force => true do |t|
    t.string   "charity_identifier"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "justgiving_payments", :force => true do |t|
    t.string   "donation_identifier", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "justgiving_payments", ["donation_identifier"], :name => "index_justgiving_payments_on_donation_identifier", :unique => true

  create_table "orders", :force => true do |t|
    t.integer  "cart_id",      :null => false
    t.integer  "payment_id",   :null => false
    t.string   "payment_type", :null => false
    t.string   "token",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "shipped_at"
    t.integer  "address_id",   :null => false
  end

  add_index "orders", ["shipped_at"], :name => "index_orders_on_shipped_at"
  add_index "orders", ["token"], :name => "index_orders_on_token", :unique => true

  create_table "packagings", :force => true do |t|
    t.integer  "product_id", :null => false
    t.string   "name",       :null => false
    t.integer  "size",       :null => false
    t.integer  "price",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "packagings", ["product_id"], :name => "index_packagings_on_product_id"

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
    t.string   "name",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store_id",    :null => false
    t.text     "description", :null => false
    t.string   "image_path",  :null => false
  end

  add_index "products", ["store_id", "name"], :name => "index_products_on_store_id_and_name", :unique => true
  add_index "products", ["store_id"], :name => "index_products_on_store_id"

  create_table "stores", :force => true do |t|
    t.string   "name",           :null => false
    t.string   "slug",           :null => false
    t.string   "currency",       :null => false
    t.integer  "distributor_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id",     :null => false
    t.string   "account_type",   :null => false
    t.text     "description",    :null => false
  end

  add_index "stores", ["slug"], :name => "index_stores_on_slug", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                   :null => false
    t.string   "password_hash",           :null => false
    t.string   "password_recovery_token", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["password_recovery_token"], :name => "index_users_on_password_recovery_token", :unique => true

end

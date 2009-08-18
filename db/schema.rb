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

ActiveRecord::Schema.define(:version => 20090818093800) do

  create_table "addresses", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "line_one"
    t.string   "line_two"
    t.string   "line_three"
    t.string   "line_four"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "distributor_donation_methods", :force => true do |t|
    t.integer  "distributor_id"
    t.integer  "donation_method_id"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "donation_methods", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "account"
  end

  create_table "donations", :force => true do |t|
    t.integer  "order_id"
    t.integer  "donation_method_id"
    t.datetime "received_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "downloads", :force => true do |t|
    t.string   "name"
    t.string   "content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "path"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", :force => true do |t|
    t.integer  "distributor_id"
    t.integer  "sku_id"
    t.integer  "initial",        :default => 0
    t.integer  "promised",       :default => 0
    t.integer  "shipped",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", :force => true do |t|
    t.integer  "list_id"
    t.integer  "variant_id"
    t.integer  "quantity",   :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lists", :force => true do |t|
    t.integer  "address_id"
    t.integer  "distributor_id"
    t.string   "type"
    t.string   "token",                      :limit => 40
    t.integer  "additional_donation_amount",               :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locators", :force => true do |t|
    t.integer "ip_from"
    t.integer "ip_to"
    t.string  "country_code",                       :limit => 2
    t.string  "country_code_with_three_characters", :limit => 3
    t.string  "country"
  end

  create_table "products", :force => true do |t|
    t.integer  "image_id"
    t.string   "name"
    t.text     "description"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shipments", :force => true do |t|
    t.integer  "order_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "skus", :force => true do |t|
    t.integer  "product_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "type"
    t.string   "name"
    t.string   "email"
    t.string   "country"
    t.string   "encrypted_password", :limit => 40
    t.string   "salt",               :limit => 40
    t.string   "country_code",       :limit => 2
    t.string   "currency",           :limit => 3
    t.integer  "position",                         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "variants", :force => true do |t|
    t.integer  "sku_id"
    t.integer  "download_id"
    t.string   "currency",    :default => "USD"
    t.integer  "cents",       :default => 0
    t.integer  "position",    :default => 0
    t.integer  "size",        :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

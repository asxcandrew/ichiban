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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121105164955) do

  create_table "boards", :force => true do |t|
    t.string   "name"
    t.string   "directory"
    t.text     "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.float    "file_size_limit"
    t.integer  "max_reports"
    t.boolean  "save_IPs"
  end

  add_index "boards", ["directory"], :name => "index_boards_on_directory", :unique => true

  create_table "images", :force => true do |t|
    t.integer  "post_id"
    t.string   "asset"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.string   "subject"
    t.string   "ip_address"
    t.string   "tripcode"
    t.string   "secure_tripcode"
    t.text     "body"
    t.string   "directory"
    t.integer  "parent_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "color"
    t.integer  "ancestor_id"
    t.boolean  "locked"
    t.integer  "replies"
  end

  add_index "posts", ["directory"], :name => "index_posts_on_directory"
  add_index "posts", ["parent_id"], :name => "index_posts_on_parent_id"

  create_table "reports", :force => true do |t|
    t.string   "ip_address"
    t.string   "model"
    t.integer  "post_id"
    t.text     "comment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "suspensions", :force => true do |t|
    t.date     "ends_at"
    t.string   "ip_address"
    t.string   "directory"
    t.integer  "post_id"
    t.text     "reason"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "role"
  end

  add_index "users", ["email"], :name => "index_users_on_email"

end

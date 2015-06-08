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

ActiveRecord::Schema.define(version: 20150608175927) do

  create_table "additions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boards", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "directory",          limit: 255
    t.text     "description",        limit: 65535
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.float    "file_size_limit",    limit: 24
    t.integer  "max_reports_per_IP", limit: 4
    t.boolean  "save_IPs",           limit: 1,     default: true
    t.boolean  "worksafe",           limit: 1,     default: true
  end

  add_index "boards", ["directory"], name: "index_boards_on_directory", unique: true, using: :btree

  create_table "boards_users", id: false, force: :cascade do |t|
    t.integer "board_id", limit: 4
    t.integer "user_id",  limit: 4
  end

  create_table "images", force: :cascade do |t|
    t.integer  "post_id",        limit: 4
    t.string   "asset",          limit: 255
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "width",          limit: 4
    t.integer  "height",         limit: 4
    t.string   "md5",            limit: 255
    t.string   "imageable_type", limit: 255
    t.integer  "imageable_id",   limit: 4
  end

  create_table "posts", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "subject",         limit: 255
    t.string   "ip_address",      limit: 255
    t.string   "tripcode",        limit: 255
    t.string   "secure_tripcode", limit: 255
    t.text     "body",            limit: 65535
    t.integer  "parent_id",       limit: 4
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "ancestor_id",     limit: 4
    t.boolean  "locked",          limit: 1
    t.integer  "replies",         limit: 4
    t.integer  "board_id",        limit: 4
    t.integer  "addition_id",     limit: 4
  end

  add_index "posts", ["parent_id"], name: "index_posts_on_parent_id", using: :btree

  create_table "reports", force: :cascade do |t|
    t.string   "ip_address", limit: 255
    t.string   "model",      limit: 255
    t.integer  "post_id",    limit: 4
    t.text     "comment",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "resource_id",   limit: 4
    t.string   "resource_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
  add_index "roles", ["name"], name: "index_roles_on_name", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string   "var",        limit: 255,   null: false
    t.text     "value",      limit: 65535
    t.integer  "thing_id",   limit: 4
    t.string   "thing_type", limit: 30
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "suspensions", force: :cascade do |t|
    t.date     "ends_at"
    t.string   "ip_address", limit: 255
    t.integer  "post_id",    limit: 4
    t.text     "reason",     limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "board_id",   limit: 4
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "role",                   limit: 255
    t.datetime "last_login"
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "login",                  limit: 255
    t.string   "confirmation_token",     limit: 255
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4
    t.integer "role_id", limit: 4
  end

  add_index "users_roles", ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree

end

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

ActiveRecord::Schema.define(:version => 20131223132924) do

  create_table "feed_entries", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.text     "url"
    t.string   "author"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "feed_id"
  end

  add_index "feed_entries", ["feed_id"], :name => "index_feed_entries_on_feed_id"

  create_table "feed_entry_users", :force => true do |t|
    t.integer "feed_id"
    t.integer "feed_entry_id"
    t.integer "user_id"
    t.boolean "read"
    t.boolean "favorite"
  end

  add_index "feed_entry_users", ["feed_entry_id"], :name => "index_feed_entry_users_on_feed_entry_id"
  add_index "feed_entry_users", ["feed_id"], :name => "index_feed_entry_users_on_feed_id"
  add_index "feed_entry_users", ["user_id"], :name => "index_feed_entry_users_on_user_id"

  create_table "feed_users", :force => true do |t|
    t.integer "feed_id"
    t.integer "user_id"
    t.integer "folder_id"
    t.string  "title"
  end

  add_index "feed_users", ["feed_id"], :name => "index_feed_users_on_feed_id"
  add_index "feed_users", ["folder_id"], :name => "index_feed_users_on_folder_id"
  add_index "feed_users", ["user_id"], :name => "index_feed_users_on_user_id"

  create_table "feeds", :force => true do |t|
    t.string   "title"
    t.string   "url"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "favicon"
  end

  add_index "feeds", ["url"], :name => "index_feeds_on_url"

  create_table "folders", :force => true do |t|
    t.string   "name"
    t.boolean  "state"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "folders", ["user_id"], :name => "index_folders_on_user_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,  :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end

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

ActiveRecord::Schema.define(version: 20131225000720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "collections", force: true do |t|
    t.integer  "parent_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followers", force: true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.boolean  "is_owner"
    t.boolean  "can_edit"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groupies", force: true do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.integer  "workspace_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "item_contents", force: true do |t|
    t.integer  "user_id"
    t.integer  "version"
    t.integer  "item_id"
    t.string   "type"
    t.text     "content"
    t.string   "url"
    t.string   "name"
    t.string   "location"
    t.datetime "start_time"
    t.boolean  "is_all_day"
    t.datetime "end_time"
    t.integer  "alert"
    t.boolean  "is_checked"
    t.integer  "order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "items", force: true do |t|
    t.integer  "position_top"
    t.integer  "position_left"
    t.integer  "item_content_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "media_files", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", force: true do |t|
    t.integer  "workspace_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "fname"
    t.string   "lname"
    t.string   "password"
    t.string   "remember_token"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_guest"
  end

  create_table "viewers", force: true do |t|
    t.integer  "user_id"
    t.integer  "item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workspaces", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

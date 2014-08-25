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

ActiveRecord::Schema.define(version: 20140819072711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "customers", force: true do |t|
    t.string  "name",      limit: 50
    t.string  "adress",    limit: 30
    t.string  "city",      limit: 20
    t.string  "post_code", limit: 10
    t.string  "country",   limit: 20
    t.text    "web"
    t.string  "mobile",    limit: 20
    t.text    "info"
    t.text    "logo"
    t.boolean "status"
  end

  create_table "notices", force: true do |t|
    t.text     "message"
    t.integer  "doer_id"
    t.integer  "target_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notices", ["doer_id"], name: "index_notices_on_doer_id", using: :btree
  add_index "notices", ["target_id"], name: "index_notices_on_target_id", using: :btree

  create_table "one_tasks", force: true do |t|
    t.uuid     "guid"
    t.string   "wbs_code",             limit: 150
    t.string   "task_name"
    t.string   "supply_name"
    t.integer  "work"
    t.date     "start_at"
    t.date     "end_at"
    t.integer  "duration_day"
    t.boolean  "milestone"
    t.string   "wbs_code_child",       limit: 150
    t.string   "wbs_code_parent",      limit: 150
    t.integer  "objects"
    t.integer  "parents"
    t.integer  "priority"
    t.boolean  "joined_field"
    t.boolean  "congestion"
    t.text     "work_plan"
    t.boolean  "managed_by_effort"
    t.boolean  "hide_bar"
    t.text     "source_group"
    t.string   "state",                limit: 50
    t.decimal  "sv"
    t.float    "spi"
    t.boolean  "equal_can_split_task"
    t.boolean  "equal_assign"
    t.text     "accent_source"
    t.text     "text1"
    t.string   "owner_assign"
    t.string   "source_type",          limit: 100
    t.string   "type_t",               limit: 50
    t.boolean  "assignment"
    t.text     "source_names"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "one_tasks", ["task_id"], name: "index_one_tasks_on_task_id", using: :btree

  create_table "projects", force: true do |t|
    t.integer "customer_id"
    t.string  "name",        limit: 50
    t.text    "info"
    t.date    "start_at"
    t.date    "end_at"
    t.decimal "budget",                 precision: 19, scale: 2
    t.boolean "status"
  end

  create_table "reports", force: true do |t|
    t.integer  "user_id"
    t.date     "date"
    t.time     "time"
    t.text     "info"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "approvement"
  end

  create_table "roles", force: true do |t|
    t.integer "user_id"
    t.text    "r_name"
    t.date    "start_at"
    t.date    "end_at"
    t.text    "state"
    t.integer "project_id"
    t.integer "task_id"
    t.string  "special",    limit: 20
  end

  create_table "t2", force: true do |t|
    t.integer "task_id"
    t.uuid    "guid"
  end

  create_table "tasks", force: true do |t|
    t.integer "project_id"
    t.uuid    "guid"
  end

  create_table "users", force: true do |t|
    t.string  "first_name",         limit: 20
    t.string  "last_name",          limit: 20
    t.text    "position"
    t.text    "department"
    t.float   "work_day"
    t.text    "photo"
    t.string  "level",              limit: 2
    t.string  "email",              limit: 50
    t.string  "encrypted_password", limit: 128
    t.string  "confirmation_token", limit: 128
    t.string  "remember_token",     limit: 128
    t.string  "city",               limit: 40
    t.string  "title",              limit: 15
    t.string  "acquirements",       limit: 40
    t.boolean "status"
  end

  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["remember_token"], name: "index_users_on_remember_token", using: :btree

end

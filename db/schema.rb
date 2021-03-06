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

ActiveRecord::Schema.define(:version => 20110513010955) do

  create_table "courses", :force => true do |t|
    t.string   "code"
    t.string   "instructor"
    t.string   "title"
    t.string   "time"
    t.string   "subject"
    t.text     "description"
    t.integer  "credits"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "time_parsed"
    t.date     "start_date"
    t.date     "end_date"
  end

  create_table "courses_time_periods", :id => false, :force => true do |t|
    t.integer "course_id"
    t.integer "time_period_id"
  end

  create_table "courses_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  create_table "options", :force => true do |t|
    t.string   "key"
    t.text     "value"
    t.boolean  "serialized"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.string   "slug"
    t.text     "content"
    t.string   "tags"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_periods", :force => true do |t|
    t.string   "time"
    t.string   "days"
    t.integer  "t_start_h"
    t.integer  "t_start_m"
    t.integer  "t_end_h"
    t.integer  "t_end_m"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "time_periods", ["time"], :name => "index_time_periods_on_time", :unique => true

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "permissions",                              :default => "user",   :null => false
    t.string   "status",                                   :default => "active", :null => false
    t.boolean  "private",                                  :default => true
    t.string   "first_name"
    t.string   "last_name"
    t.string   "preferred_name"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end

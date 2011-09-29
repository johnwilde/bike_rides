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

ActiveRecord::Schema.define(:version => 20110929034455) do

  create_table "rides", :force => true do |t|
    t.integer  "fusiontable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "ridedata"
    t.float    "centroid_lat"
    t.float    "centroid_lon"
    t.float    "bb_sw_lat"
    t.float    "bb_sw_lon"
    t.float    "bb_ne_lat"
    t.float    "bb_ne_lon"
    t.integer  "user_id"
    t.text     "description"
    t.float    "total_distance"
    t.integer  "total_time"
    t.integer  "moving_time"
    t.float    "avg_speed"
    t.float    "avg_moving_speed"
    t.float    "max_speed"
    t.float    "min_elevation"
    t.float    "max_elevation"
    t.float    "elevation_gain"
    t.float    "max_grade"
    t.float    "min_grade"
    t.datetime "recorded"
    t.text     "private_description"
  end

  add_index "rides", ["user_id", "created_at"], :name => "index_rides_on_user_id_and_created_at"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
    t.string   "secret"
    t.boolean  "admin",            :default => false
    t.integer  "ride_id"
    t.string   "email"
    t.boolean  "use_metric_units"
  end

end

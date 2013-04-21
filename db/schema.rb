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

ActiveRecord::Schema.define(:version => 20130421040200) do

  create_table "global_weather_reports", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "weather_reports", :force => true do |t|
    t.string   "name"
    t.float    "minimum_temperature"
    t.float    "maximum_temperature"
    t.string   "description"
    t.float    "wind_speed"
    t.float    "wind_direction"
    t.float    "latitude"
    t.float    "longitude"
    t.time     "sunset"
    t.time     "sunrise"
    t.float    "pressure"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "global_weather_report_id"
  end

end

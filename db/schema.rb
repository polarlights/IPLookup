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

ActiveRecord::Schema.define(version: 20150328132642) do

  create_table "ipcodes", id: false, force: :cascade do |t|
    t.integer "ip_start", limit: 4,   default: 0
    t.integer "ip_end",   limit: 4,   default: 0
    t.integer "area_id",  limit: 4,   default: 0
    t.string  "other",    limit: 255, default: ""
  end

  add_index "ipcodes", ["area_id"], name: "index_ipcodes_on_area_id", unique: true, using: :btree
  add_index "ipcodes", ["ip_end"], name: "index_ipcodes_on_ip_end", unique: true, using: :btree
  add_index "ipcodes", ["ip_start"], name: "index_ipcodes_on_ip_start", unique: true, using: :btree

  create_table "main_areas", id: false, force: :cascade do |t|
    t.integer "area_id",   limit: 4,   default: 0
    t.string  "area_name", limit: 255, default: ""
    t.integer "parent_id", limit: 4,   default: 0
  end

  add_index "main_areas", ["area_id"], name: "index_main_areas_on_area_id", unique: true, using: :btree
  add_index "main_areas", ["parent_id"], name: "index_main_areas_on_parent_id", using: :btree

end

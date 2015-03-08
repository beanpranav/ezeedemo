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

ActiveRecord::Schema.define(version: 20150308113759) do

  create_table "chapters", force: true do |t|
    t.string   "name"
    t.integer  "chapterNumber"
    t.integer  "term"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "subject_id"
    t.string   "slug"
    t.string   "status"
  end

  add_index "chapters", ["slug"], name: "index_chapters_on_slug", unique: true
  add_index "chapters", ["subject_id"], name: "index_chapters_on_subject_id"

  create_table "study_materials", force: true do |t|
    t.string   "name"
    t.text     "video_source"
    t.integer  "video_duration"
    t.text     "model_source"
    t.integer  "chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

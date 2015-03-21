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

ActiveRecord::Schema.define(version: 20150321085442) do

  create_table "assessment_contents", force: true do |t|
    t.integer  "video_content_id"
    t.text     "question"
    t.text     "choice_a"
    t.text     "choice_b"
    t.text     "choice_c"
    t.text     "choice_d"
    t.string   "answer"
    t.string   "difficulty_level"
    t.string   "next_step"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "next_step"
    t.integer  "material_no"
    t.string   "admin_incharge"
    t.integer  "chapter_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "material_type"
    t.integer  "video_content_id"
    t.integer  "interactive_content_id"
  end

  create_table "subjects", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "board"
    t.integer  "standard"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",        null: false
    t.string   "encrypted_password",     default: "",        null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "phone_number"
    t.string   "role",                   default: "Student"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "video_contents", force: true do |t|
    t.string   "content_type"
    t.string   "name"
    t.integer  "video_duration"
    t.date     "production_date"
    t.string   "producer_name"
    t.string   "admin_note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "content"
  end

end

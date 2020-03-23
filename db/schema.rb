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

ActiveRecord::Schema.define(version: 2020_03_23_135359) do

  create_table "comments", force: :cascade do |t|
    t.string "comment"
    t.string "createdby"
    t.string "sentiment"
    t.integer "profile_id"
    t.integer "news_report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["news_report_id"], name: "index_comments_on_news_report_id"
    t.index ["profile_id"], name: "index_comments_on_profile_id"
  end

  create_table "follows", force: :cascade do |t|
    t.string "followee_id"
    t.integer "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_id"], name: "index_follows_on_profile_id"
  end

  create_table "news_reports", force: :cascade do |t|
    t.string "title"
    t.string "category"
    t.text "content"
    t.integer "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "createdby"
    t.integer "comments_id"
    t.index ["comments_id"], name: "index_news_reports_on_comments_id"
    t.index ["profile_id"], name: "index_news_reports_on_profile_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "fname"
    t.string "sname"
    t.string "bio"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.integer "no_of_followers"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.integer "profile_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["profile_id"], name: "index_users_on_profile_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

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

ActiveRecord::Schema.define(version: 20140909061135) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blackcards", force: true do |t|
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", force: true do |t|
    t.string  "name",      limit: 30
    t.integer "round_num",            default: 1
  end

  create_table "playable_cards", force: true do |t|
    t.integer  "seat_id"
    t.integer  "whitecard_id"
    t.boolean  "submitted",    default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", force: true do |t|
    t.integer "game_id"
    t.integer "leader_id"
    t.integer "blackcard_id"
    t.integer "round_num"
  end

  create_table "seats", force: true do |t|
    t.integer "user_id"
    t.integer "game_id"
    t.integer "score",   default: 0
  end

  create_table "submissions", force: true do |t|
    t.integer "round_id"
    t.integer "playable_card_id"
    t.boolean "winner",           default: false
  end

  create_table "users", force: true do |t|
    t.string   "name",            limit: 30, null: false
    t.string   "email"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
  end

  create_table "whitecards", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

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

ActiveRecord::Schema.define(version: 20170407151539) do

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "forms", force: :cascade do |t|
    t.string   "col1"
    t.string   "col2"
    t.string   "col3"
    t.string   "col4"
    t.string   "col5"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sports", force: :cascade do |t|
    t.string   "title"
    t.string   "winner"
    t.string   "loser"
    t.string   "wp"
    t.string   "lp"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "teamone"
    t.string   "teamtwo"
    t.string   "status"
    t.string   "hour"
    t.string   "minute"
    t.string   "week"
    t.string   "wday"
    t.string   "place"
    t.integer  "category_id"
    t.index ["category_id"], name: "index_sports_on_category_id"
  end

  create_table "sports_teams", id: false, force: :cascade do |t|
    t.integer "sport_id"
    t.integer "team_id"
    t.index ["sport_id"], name: "index_sports_teams_on_sport_id"
    t.index ["team_id"], name: "index_sports_teams_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "points"
    t.string   "group"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "category_id"
    t.index ["category_id"], name: "index_teams_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end

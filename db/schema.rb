# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_03_03_030017) do
  create_table "players", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "dunk"
    t.string "first_name"
    t.string "height"
    t.string "last_name"
    t.integer "overall"
    t.integer "overall_rank"
    t.string "position"
    t.string "team"
    t.integer "three_pt"
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
    t.integer "c_id"
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.integer "pf_id"
    t.integer "pg_id"
    t.string "session_token"
    t.integer "sf_id"
    t.integer "sg_id"
    t.datetime "updated_at", null: false
    t.index ["c_id"], name: "index_teams_on_c_id"
    t.index ["ip_address"], name: "index_teams_on_ip_address"
    t.index ["pf_id"], name: "index_teams_on_pf_id"
    t.index ["pg_id"], name: "index_teams_on_pg_id"
    t.index ["session_token"], name: "index_teams_on_session_token"
    t.index ["sf_id"], name: "index_teams_on_sf_id"
    t.index ["sg_id"], name: "index_teams_on_sg_id"
  end
end

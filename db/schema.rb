# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_11_08_083519) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "auth_attempts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "profile_id"
    t.string "secret"
    t.boolean "expired", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expired"], name: "index_auth_attempts_on_expired"
    t.index ["profile_id"], name: "index_auth_attempts_on_profile_id"
  end

  create_table "cameras", force: :cascade do |t|
    t.string "make"
    t.string "model"
    t.index ["make"], name: "index_cameras_on_make"
    t.index ["model"], name: "index_cameras_on_model"
  end

  create_table "clusters", force: :cascade do |t|
    t.integer "members", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "profile_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "secret"
    t.index ["profile_id"], name: "index_devices_on_profile_id"
  end

  create_table "folders", force: :cascade do |t|
    t.string "path"
    t.integer "folder_id"
    t.integer "depth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string "digest"
    t.string "filetype"
    t.string "original_filepath"
    t.string "current_filepath"
    t.datetime "modifydate"
    t.datetime "createdate"
    t.integer "imagewidth"
    t.integer "imageheight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "shot_id"
    t.bigint "folder_id"
    t.index ["createdate"], name: "index_photos_on_createdate"
    t.index ["current_filepath"], name: "index_photos_on_current_filepath"
    t.index ["digest"], name: "index_photos_on_digest"
    t.index ["filetype"], name: "index_photos_on_filetype"
    t.index ["folder_id"], name: "index_photos_on_folder_id"
    t.index ["original_filepath"], name: "index_photos_on_original_filepath"
  end

  create_table "profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_profiles_on_name", unique: true
  end

  create_table "sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "device_id"
    t.string "access_token"
    t.boolean "expired", default: false, null: false
    t.datetime "active_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_sessions_on_access_token"
    t.index ["device_id"], name: "index_sessions_on_device_id"
  end

  create_table "shots", force: :cascade do |t|
    t.string "name"
    t.string "orientation"
    t.string "gpslatitude"
    t.string "gpslongitude"
    t.integer "camera_id"
    t.datetime "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "date_source"
    t.index ["date"], name: "index_shots_on_date"
  end

  create_table "unprocessed_files", force: :cascade do |t|
    t.string "file"
    t.string "metadata"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "auth_attempts", "profiles"
  add_foreign_key "devices", "profiles"
  add_foreign_key "photos", "folders"
  add_foreign_key "photos", "shots"
  add_foreign_key "sessions", "devices"
  add_foreign_key "shots", "cameras"
end

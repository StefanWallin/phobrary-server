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

ActiveRecord::Schema.define(version: 20171213190336) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "photos", force: :cascade do |t|
    t.string "digest"
    t.string "filetype"
    t.string "original_filepath"
    t.string "current_filepath"
    t.datetime "modifydate"
    t.datetime "createdate"
    t.string "make"
    t.string "model"
    t.string "orientation"
    t.integer "imagewidth"
    t.integer "imageheight"
    t.string "gpslatitude"
    t.string "gpslongitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["createdate"], name: "index_photos_on_createdate"
    t.index ["current_filepath"], name: "index_photos_on_current_filepath"
    t.index ["digest"], name: "index_photos_on_digest", unique: true
    t.index ["filetype"], name: "index_photos_on_filetype"
    t.index ["original_filepath"], name: "index_photos_on_original_filepath"
  end

end

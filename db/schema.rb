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

ActiveRecord::Schema.define(version: 2013_10_05_210742) do

  create_table "clubs", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "email", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "comment"
    t.boolean "resolved"
    t.boolean "void"
    t.string "submitter_email", limit: 255
    t.integer "map_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "attachment_file_name", limit: 255
    t.string "attachment_content_type", limit: 255
    t.integer "attachment_file_size"
    t.datetime "attachment_updated_at"
    t.integer "map_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "title", limit: 255
    t.float "lat"
    t.float "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "map_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "worldofo_title", limit: 255
    t.string "title", limit: 255
    t.string "icon", limit: 255
  end

  create_table "maps", force: :cascade do |t|
    t.string "identifier", limit: 255
    t.string "title", limit: 255
    t.integer "club_id"
    t.integer "map_type_id"
    t.integer "year"
    t.string "mapper", limit: 255
    t.integer "scale"
    t.float "contours"
    t.float "size"
    t.float "lat"
    t.float "lng"
    t.string "city", limit: 255
    t.string "zip", limit: 255
    t.string "count", limit: 255
    t.string "region", limit: 255
    t.string "contact_email", limit: 255
    t.string "website", limit: 255
    t.text "description"
    t.text "comment"
    t.boolean "access_permission_needed"
    t.boolean "approved"
    t.boolean "published"
    t.string "submitter_email", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "worldofo_id"
    t.boolean "imported"
    t.string "price", limit: 255
    t.string "status", limit: 255
    t.string "url", limit: 255
    t.string "download_file_name", limit: 255
    t.string "download_content_type", limit: 255
    t.integer "download_file_size"
    t.datetime "download_updated_at"
    t.integer "submitter_id"
    t.integer "last_editor_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name", limit: 255
    t.string "abbreviation", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email", limit: 255
    t.string "firstname", limit: 255
    t.string "lastname", limit: 255
    t.boolean "is_admin"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end

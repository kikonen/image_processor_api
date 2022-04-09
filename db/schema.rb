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

ActiveRecord::Schema[7.0].define(version: 2022_04_09_205311) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "exif_values", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "value"
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.uuid "image_id", null: false
    t.index ["image_id"], name: "idx_exif_value_image"
  end

  create_table "images", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "url", null: false
    t.string "status", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.uuid "upload_id", null: false
    t.index ["upload_id"], name: "idx_image_upload"
  end

  create_table "tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "token", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.uuid "user_id", null: false
    t.index ["token"], name: "index_tokens_on_token", unique: true
    t.index ["user_id"], name: "idx_token_user"
  end

  create_table "uploads", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.uuid "user_id", null: false
    t.index ["user_id"], name: "idx_upload_user"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.datetime "created_at", default: -> { "now()" }, null: false
    t.datetime "updated_at", default: -> { "now()" }, null: false
    t.index ["email"], name: "idx_user_email", unique: true
  end

  add_foreign_key "exif_values", "images"
  add_foreign_key "images", "uploads"
  add_foreign_key "tokens", "users"
  add_foreign_key "uploads", "users"
end

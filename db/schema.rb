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

ActiveRecord::Schema[8.0].define(version: 2025_04_29_231112) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ai_recommendations", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "task_type"
    t.date "suggested_date"
    t.bigint "boat_id", null: false
    t.bigint "system_component_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["boat_id"], name: "index_ai_recommendations_on_boat_id"
    t.index ["system_component_id"], name: "index_ai_recommendations_on_system_component_id"
  end

  create_table "boats", force: :cascade do |t|
    t.string "name"
    t.string "make"
    t.string "model"
    t.integer "year"
    t.string "engine_type"
    t.string "location"
    t.integer "hours"
    t.text "description"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_boats_on_user_id"
  end

  create_table "maintenance_tasks", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "completed_at"
    t.date "due_date"
    t.decimal "cost"
    t.integer "engine_hours"
    t.text "notes"
    t.bigint "boat_id", null: false
    t.bigint "system_component_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "task_type"
    t.index ["boat_id"], name: "index_maintenance_tasks_on_boat_id"
    t.index ["system_component_id"], name: "index_maintenance_tasks_on_system_component_id"
  end

  create_table "system_components", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_prompts", force: :cascade do |t|
    t.text "content"
    t.text "response"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_prompts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "ai_recommendations", "boats"
  add_foreign_key "ai_recommendations", "system_components"
  add_foreign_key "maintenance_tasks", "boats"
  add_foreign_key "maintenance_tasks", "system_components"
  add_foreign_key "user_prompts", "users"
end

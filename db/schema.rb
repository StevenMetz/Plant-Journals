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

ActiveRecord::Schema[7.1].define(version: 2024_04_22_230829) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "plant_journals", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_plant_journals_on_user_id"
  end

  create_table "plants", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.string "likes"
    t.string "dislikes"
    t.string "water_frequency"
    t.string "temperature"
    t.string "sun_light_exposure"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "plant_journal_id"
    t.bigint "user_id"
    t.index ["plant_journal_id"], name: "index_plants_on_plant_journal_id"
    t.index ["user_id"], name: "index_plants_on_user_id"
  end

  create_table "shared_journals", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "plant_journal_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plant_journal_id"], name: "index_shared_journals_on_plant_journal_id"
    t.index ["user_id"], name: "index_shared_journals_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "jti", null: false
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "plant_journals", "users"
  add_foreign_key "plants", "plant_journals"
  add_foreign_key "plants", "users"
  add_foreign_key "shared_journals", "plant_journals"
  add_foreign_key "shared_journals", "users"
end

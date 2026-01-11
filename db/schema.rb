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

ActiveRecord::Schema[8.0].define(version: 2026_01_09_201312) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "achievements", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.string "badge_icon", null: false
    t.integer "category", default: 0, null: false
    t.integer "points_required", default: 0
    t.integer "exercises_required", default: 0
    t.integer "streak_required", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_achievements_on_category"
    t.index ["name"], name: "index_achievements_on_name", unique: true
  end

  create_table "code_submissions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exercise_id", null: false
    t.text "code", null: false
    t.text "result"
    t.boolean "passed", default: false, null: false
    t.float "execution_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_code_submissions_on_exercise_id"
    t.index ["passed"], name: "index_code_submissions_on_passed"
    t.index ["user_id", "exercise_id", "created_at"], name: "index_submissions_on_user_exercise_time"
    t.index ["user_id"], name: "index_code_submissions_on_user_id"
  end

  create_table "exercises", force: :cascade do |t|
    t.bigint "lesson_id", null: false
    t.string "title", null: false
    t.text "description"
    t.text "instructions"
    t.jsonb "hints", default: []
    t.text "starter_code"
    t.text "solution_code"
    t.text "test_code", null: false
    t.jsonb "topics", default: []
    t.integer "points", default: 10, null: false
    t.integer "position", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title_ru"
    t.text "description_ru"
    t.text "instructions_ru"
    t.jsonb "hints_ru", default: []
    t.index ["lesson_id", "position"], name: "index_exercises_on_lesson_id_and_position", unique: true
    t.index ["lesson_id"], name: "index_exercises_on_lesson_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.integer "module_number", null: false
    t.integer "position", default: 0, null: false
    t.integer "difficulty", default: 0, null: false
    t.string "ruby_version", default: "3.4", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title_ru"
    t.text "description_ru"
    t.index ["module_number", "position"], name: "index_lessons_on_module_number_and_position", unique: true
    t.index ["module_number"], name: "index_lessons_on_module_number"
  end

  create_table "user_achievements", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "achievement_id", null: false
    t.datetime "earned_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["achievement_id"], name: "index_user_achievements_on_achievement_id"
    t.index ["user_id", "achievement_id"], name: "index_user_achievements_on_user_id_and_achievement_id", unique: true
    t.index ["user_id"], name: "index_user_achievements_on_user_id"
  end

  create_table "user_progresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "exercise_id", null: false
    t.integer "status", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "last_code"
    t.datetime "completed_at"
    t.integer "points_earned", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exercise_id"], name: "index_user_progresses_on_exercise_id"
    t.index ["user_id", "exercise_id"], name: "index_user_progresses_on_user_id_and_exercise_id", unique: true
    t.index ["user_id"], name: "index_user_progresses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "username"
    t.integer "level", default: 1, null: false
    t.integer "total_points", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_streak", default: 0, null: false
    t.integer "longest_streak", default: 0, null: false
    t.date "last_activity_date"
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "code_submissions", "exercises"
  add_foreign_key "code_submissions", "users"
  add_foreign_key "exercises", "lessons"
  add_foreign_key "user_achievements", "achievements"
  add_foreign_key "user_achievements", "users"
  add_foreign_key "user_progresses", "exercises"
  add_foreign_key "user_progresses", "users"
end

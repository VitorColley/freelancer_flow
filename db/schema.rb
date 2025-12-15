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

ActiveRecord::Schema[8.1].define(version: 2025_12_15_081857) do
  create_table "invoices", force: :cascade do |t|
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "issued_at"
    t.integer "project_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_invoices_on_project_id"
  end

  create_table "portfolio_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "freelancer_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["freelancer_id"], name: "index_portfolio_items_on_freelancer_id"
  end

  create_table "projects", force: :cascade do |t|
    t.decimal "budget"
    t.integer "client_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_projects_on_client_id"
  end

  create_table "proposals", force: :cascade do |t|
    t.decimal "bid_amount"
    t.datetime "created_at", null: false
    t.integer "freelancer_id", null: false
    t.text "message"
    t.integer "project_id", null: false
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["freelancer_id"], name: "index_proposals_on_freelancer_id"
    t.index ["project_id"], name: "index_proposals_on_project_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.integer "project_id", null: false
    t.integer "rating"
    t.integer "reviewee_id", null: false
    t.integer "reviewer_id", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_reviews_on_project_id"
    t.index ["reviewee_id"], name: "index_reviews_on_reviewee_id"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "user_skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "skill_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["skill_id"], name: "index_user_skills_on_skill_id"
    t.index ["user_id"], name: "index_user_skills_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "name"
    t.string "password_digest", null: false
    t.string "role"
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
  end

  add_foreign_key "invoices", "projects"
  add_foreign_key "portfolio_items", "freelancers"
  add_foreign_key "projects", "clients"
  add_foreign_key "proposals", "freelancers"
  add_foreign_key "proposals", "projects"
  add_foreign_key "reviews", "projects"
  add_foreign_key "reviews", "reviewees"
  add_foreign_key "reviews", "reviewers"
  add_foreign_key "sessions", "users"
  add_foreign_key "user_skills", "skills"
  add_foreign_key "user_skills", "users"
end

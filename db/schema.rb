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

ActiveRecord::Schema.define(version: 2020_08_19_204835) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "grab_lists", force: :cascade do |t|
    t.string "field_name"
    t.text "text"
    t.string "xpath"
    t.string "page_url"
    t.boolean "inactive"
    t.integer "program_id"
    t.integer "site_id"
    t.integer "poc_id"
    t.bigint "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_grab_lists_on_org_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "addr1"
    t.string "addr2"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "phone"
    t.string "email"
    t.boolean "primary_poc"
    t.boolean "inactive"
    t.bigint "sites_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sites_id"], name: "index_locations_on_sites_id"
  end

  create_table "orgs", force: :cascade do |t|
    t.string "domain"
    t.string "name"
    t.text "description_display"
    t.string "org_type"
    t.string "home_url"
    t.boolean "inactive"
    t.boolean "referral"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pocs", force: :cascade do |t|
    t.string "poc_name"
    t.string "title"
    t.string "mobile"
    t.string "work"
    t.string "email"
    t.boolean "inactive"
    t.bigint "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_pocs_on_org_id"
  end

  create_table "population_groups", force: :cascade do |t|
    t.string "name"
    t.boolean "inactive"
    t.integer "call_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "population_tags", force: :cascade do |t|
    t.string "name"
    t.boolean "inactive"
    t.integer "call_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "program_pocs", force: :cascade do |t|
    t.bigint "program_id"
    t.bigint "poc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poc_id"], name: "index_program_pocs_on_poc_id"
    t.index ["program_id"], name: "index_program_pocs_on_program_id"
  end

  create_table "program_population_groups", force: :cascade do |t|
    t.bigint "org_id"
    t.bigint "program_id"
    t.bigint "population_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_program_population_groups_on_org_id"
    t.index ["population_group_id"], name: "index_program_population_groups_on_population_group_id"
    t.index ["program_id"], name: "index_program_population_groups_on_program_id"
  end

  create_table "program_population_tags", force: :cascade do |t|
    t.bigint "org_id"
    t.bigint "program_id"
    t.bigint "population_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_program_population_tags_on_org_id"
    t.index ["population_tag_id"], name: "index_program_population_tags_on_population_tag_id"
    t.index ["program_id"], name: "index_program_population_tags_on_program_id"
  end

  create_table "program_service_groups", force: :cascade do |t|
    t.bigint "org_id"
    t.bigint "program_id"
    t.bigint "service_group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_program_service_groups_on_org_id"
    t.index ["program_id"], name: "index_program_service_groups_on_program_id"
    t.index ["service_group_id"], name: "index_program_service_groups_on_service_group_id"
  end

  create_table "program_service_tags", force: :cascade do |t|
    t.bigint "org_id"
    t.bigint "program_id"
    t.bigint "service_tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_program_service_tags_on_org_id"
    t.index ["program_id"], name: "index_program_service_tags_on_program_id"
    t.index ["service_tag_id"], name: "index_program_service_tags_on_service_tag_id"
  end

  create_table "program_sites", force: :cascade do |t|
    t.bigint "program_id"
    t.bigint "site_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_program_sites_on_program_id"
    t.index ["site_id"], name: "index_program_sites_on_site_id"
  end

  create_table "programs", force: :cascade do |t|
    t.string "name"
    t.string "quick_url"
    t.string "contact_url"
    t.string "program_url"
    t.text "program_description_display"
    t.text "population_description_display"
    t.text "service_area_description_display"
    t.boolean "inactive"
    t.bigint "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_programs_on_org_id"
  end

  create_table "scopes", force: :cascade do |t|
    t.string "geo_scope"
    t.string "neigborhood"
    t.string "city"
    t.string "county"
    t.string "state"
    t.string "region"
    t.string "country"
    t.boolean "inactive"
    t.integer "program_id"
    t.bigint "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_scopes_on_org_id"
  end

  create_table "service_groups", force: :cascade do |t|
    t.string "name"
    t.string "vocabulary"
    t.boolean "inactive"
    t.integer "call_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "service_tags", force: :cascade do |t|
    t.string "name"
    t.boolean "inactive"
    t.integer "call_total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "site_pocs", force: :cascade do |t|
    t.bigint "site_id"
    t.bigint "poc_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["poc_id"], name: "index_site_pocs_on_poc_id"
    t.index ["site_id"], name: "index_site_pocs_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "site_name"
    t.string "site_url"
    t.string "site_ref"
    t.boolean "admin"
    t.boolean "delivery"
    t.boolean "resource_dir"
    t.boolean "inactive"
    t.bigint "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_sites_on_org_id"
  end

  add_foreign_key "locations", "sites", column: "sites_id"
  add_foreign_key "program_pocs", "pocs"
  add_foreign_key "program_pocs", "programs"
  add_foreign_key "program_service_groups", "programs"
  add_foreign_key "program_service_groups", "service_groups"
  add_foreign_key "program_sites", "programs"
  add_foreign_key "program_sites", "sites"
  add_foreign_key "site_pocs", "pocs"
  add_foreign_key "site_pocs", "sites"
end

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

ActiveRecord::Schema.define(version: 2022_09_21_174034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_credentials", force: :cascade do |t|
    t.string "api_key"
  end

  create_table "collection_infos", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.string "title"
    t.string "short_title"
    t.string "version"
    t.string "version_description"
    t.string "abstract"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "bucket"
    t.string "path"
    t.string "filename_prefix"
    t.index ["questionnaire_id"], name: "index_collection_infos_on_questionnaire_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_contacts_on_questionnaire_id"
  end

  create_table "data_infos", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.string "format"
    t.float "size"
    t.string "constraints"
    t.string "compression_state"
    t.string "naming_convention_text"
    t.string "naming_convention"
    t.string "quality_assurance"
    t.string "software_package"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_data_infos_on_questionnaire_id"
  end

  create_table "datasets", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.string "title"
    t.string "version"
    t.string "version_description"
    t.string "description"
    t.string "doi"
    t.string "processing_level"
    t.string "public"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "other_processing_level"
    t.index ["questionnaire_id"], name: "index_datasets_on_questionnaire_id"
  end

  create_table "insitus", force: :cascade do |t|
    t.bigint "spatial_extent_id"
    t.string "measurement"
    t.string "radius"
    t.string "lon"
    t.string "lat"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spatial_extent_id"], name: "index_insitus_on_spatial_extent_id"
  end

  create_table "instruments", force: :cascade do |t|
    t.bigint "platform_id"
    t.string "name"
    t.index ["platform_id"], name: "index_instruments_on_platform_id"
  end

  create_table "keywords", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.json "science_keywords"
    t.string "ancillary_keywords"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_keywords_on_questionnaire_id"
  end

  create_table "organization_catalogues", force: :cascade do |t|
    t.bigint "organization_id"
    t.bigint "contact_id"
    t.index ["contact_id"], name: "index_organization_catalogues_on_contact_id"
    t.index ["organization_id"], name: "index_organization_catalogues_on_organization_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.bigint "contact_id"
    t.string "name"
    t.string "email"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_organizations_on_contact_id"
  end

  create_table "people", force: :cascade do |t|
    t.bigint "contact_id"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "email"
    t.string "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_people_on_contact_id"
  end

  create_table "person_catalogues", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "contact_id"
    t.index ["contact_id"], name: "index_person_catalogues_on_contact_id"
    t.index ["person_id"], name: "index_person_catalogues_on_person_id"
  end

  create_table "platforms", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_platforms_on_questionnaire_id"
  end

  create_table "projects", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.string "name"
    t.string "agency"
    t.string "program"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_projects_on_questionnaire_id"
  end

  create_table "questionnaires", force: :cascade do |t|
    t.string "user_name"
    t.string "user_email"
    t.boolean "finished"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
  end

  create_table "related_infos", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.string "published_paper_url"
    t.string "user_documentation_url"
    t.string "algo_documentation_url"
    t.string "published_paper", default: [], array: true
    t.string "user_documentation", default: [], array: true
    t.string "algo_documentation", default: [], array: true
    t.boolean "browse_imagery"
    t.string "additional_info"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_related_infos_on_questionnaire_id"
  end

  create_table "spatial_extents", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.string "spatial_nature"
    t.string "bounding_box_north"
    t.string "bounding_box_south"
    t.string "bounding_box_west"
    t.string "bounding_box_east"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_spatial_extents_on_questionnaire_id"
  end

  create_table "temporal_extents", force: :cascade do |t|
    t.bigint "questionnaire_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "ongoing"
    t.string "missing_explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["questionnaire_id"], name: "index_temporal_extents_on_questionnaire_id"
  end

  create_table "variables", force: :cascade do |t|
    t.bigint "data_info_id"
    t.string "name"
    t.string "unit"
    t.float "scaling_factor"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["data_info_id"], name: "index_variables_on_data_info_id"
  end

end

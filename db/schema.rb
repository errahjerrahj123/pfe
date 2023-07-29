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

ActiveRecord::Schema[7.0].define(version: 2023_06_08_175622) do
  create_table "batch_events", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "event_id"
    t.integer "batch_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["batch_id"], name: "index_batch_events_on_batch_id"
  end

  create_table "batch_groups", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "course_id"
    t.string "name"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "batch_grp_students", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "batch_grp_id"
    t.integer "student_id"
  end

  create_table "batch_grps", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "batch_id"
    t.integer "nb_group"
    t.integer "student_id"
    t.boolean "status"
    t.integer "group_id"
  end

  create_table "batch_students", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "student_id"
    t.integer "batch_id"
    t.string "nb_val"
    t.index ["batch_id", "student_id"], name: "index_batch_students_on_batch_id_and_student_id"
  end

  create_table "batches", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "course_id"
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.boolean "is_active", default: true
    t.boolean "is_deleted", default: false
    t.string "employee_id"
    t.integer "school_field_id"
    t.string "code_etude", limit: 32
    t.integer "cycle_id"
    t.boolean "is_active_mobilitie"
    t.index ["employee_id"], name: "idx101"
    t.index ["is_deleted", "is_active", "course_id", "name"], name: "index_batches_on_is_deleted_and_is_active_and_course_id_and_name"
  end

  create_table "configurations", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "config_key"
    t.string "config_value"
    t.index ["config_key"], name: "index_configurations_on_config_key", length: 10
    t.index ["config_value"], name: "index_configurations_on_config_value", length: 10
  end

  create_table "countries", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "code"
  end

  create_table "courses", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "course_name"
    t.string "code"
    t.string "section_name"
    t.boolean "is_deleted", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "grading_type"
    t.integer "cycle_id"
    t.integer "ordre"
    t.index ["grading_type"], name: "index_courses_on_grading_type"
  end

  create_table "courses_observation_groups", id: false, charset: "latin1", force: :cascade do |t|
    t.integer "course_id"
    t.integer "observation_group_id"
    t.index ["course_id"], name: "index_courses_observation_groups_on_course_id"
    t.index ["observation_group_id"], name: "index_courses_observation_groups_on_observation_group_id"
  end

  create_table "cycles", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "code"
  end

  create_table "employees", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "employee_category_id"
    t.string "employee_number"
    t.date "joining_date"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.boolean "gender"
    t.string "job_title"
    t.integer "employee_position_id"
    t.integer "employee_department_id"
    t.integer "reporting_manager_id"
    t.integer "employee_grade_id"
    t.string "qualification"
    t.text "experience_detail"
    t.integer "experience_year"
    t.integer "experience_month"
    t.boolean "status"
    t.string "status_description"
    t.date "date_of_birth"
    t.string "marital_status"
    t.integer "children_count"
    t.string "father_name"
    t.string "mother_name"
    t.string "husband_name"
    t.string "blood_group"
    t.integer "nationality_id"
    t.string "home_address_line1"
    t.string "home_address_line2"
    t.string "home_city"
    t.string "home_state"
    t.integer "home_country_id"
    t.string "home_pin_code"
    t.string "office_address_line1"
    t.string "office_address_line2"
    t.string "office_city"
    t.string "office_state"
    t.integer "office_country_id"
    t.string "office_pin_code"
    t.string "office_phone1"
    t.string "office_phone2"
    t.string "mobile_phone"
    t.string "home_phone"
    t.string "email"
    t.string "fax"
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.binary "photo_data", size: :medium
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "photo_file_size"
    t.integer "user_id"
    t.integer "school_id"
    t.string "vh"
    t.date "retirement_date"
    t.string "cin"
    t.string "speciality"
    t.string "vh_month"
    t.index ["employee_number"], name: "index_employees_on_employee_number", length: 10
  end

  create_table "grading_levels", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "batch_id"
    t.integer "min_score"
    t.integer "order"
    t.boolean "is_deleted", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.decimal "credit_points", precision: 15, scale: 2
    t.string "description"
    t.index ["batch_id", "is_deleted"], name: "index_grading_levels_on_batch_id_and_is_deleted"
  end

  create_table "grouped_batches", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "batch_group_id"
    t.integer "batch_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["batch_group_id"], name: "index_grouped_batches_on_batch_group_id"
  end

  create_table "grouped_exam_reports", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "batch_id"
    t.integer "student_id"
    t.integer "exam_group_id"
    t.decimal "marks", precision: 15, scale: 2
    t.string "score_type"
    t.integer "subject_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["batch_id", "student_id", "score_type"], name: "by_batch_student_and_score_type"
  end

  create_table "grouped_exams", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "exam_group_id"
    t.integer "batch_id"
    t.decimal "weightage", precision: 15, scale: 2
    t.index ["batch_id", "exam_group_id"], name: "index_grouped_exams_on_batch_id_and_exam_group_id"
    t.index ["batch_id"], name: "index_grouped_exams_on_batch_id"
  end

  create_table "grp_batch_batches", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "grp_batch_id"
    t.integer "batch_id"
  end

  create_table "grp_batches", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "course_id"
  end

  create_table "guardians", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "ward_id"
    t.string "first_name"
    t.string "last_name"
    t.string "relation"
    t.string "email"
    t.string "office_phone1"
    t.string "office_phone2"
    t.string "mobile_phone"
    t.string "office_address_line1"
    t.string "office_address_line2"
    t.string "city"
    t.string "state"
    t.integer "country_id"
    t.date "dob"
    t.string "occupation"
    t.string "income"
    t.string "education"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
  end

  create_table "requestdoc_students", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "student_id"
    t.integer "requestdoc_id"
    t.integer "statut"
    t.date "recovery_date"
    t.text "reject_cause"
    t.text "observation"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "school_year"
    t.integer "school_field_id"
    t.integer "batch_id"
    t.datetime "last_print_date", precision: nil
    t.date "delib_date"
    t.string "batch_ids"
    t.float "bourse_mt"
    t.string "rdv_doc"
    t.datetime "date_rdv_p", precision: nil
    t.integer "edited_by"
    t.string "doc_specification"
    t.text "details"
    t.time "start_time"
    t.time "end_time"
    t.boolean "signed"
    t.text "motif"
    t.integer "validated_by"
    t.string "file_hex"
    t.string "code_hex"
  end

  create_table "requestdocs", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.integer "nb_max"
    t.text "observation"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "save_fields", id: false, charset: "latin1", options: "ENGINE=MyISAM", force: :cascade do |t|
    t.integer "id", default: 0, null: false
    t.string "name"
    t.string "code"
    t.string "description_file_path"
    t.date "start_date_accreditation"
    t.date "end_date_accreditation"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "employee_id"
    t.text "description"
    t.integer "field_root"
    t.integer "school_id"
    t.string "name_english"
  end

  create_table "school_details", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "school_id"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.string "logo_file_size"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "school_field_effectifs", id: :integer, charset: "latin1", force: :cascade do |t|
    t.integer "school_field_id", null: false
    t.string "school_year"
    t.integer "course_id", null: false
    t.integer "nombre_place", null: false
  end

  create_table "school_field_school_modules", id: :integer, charset: "latin1", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.decimal "coefficient", precision: 7, scale: 2
    t.integer "school_field_id"
    t.integer "school_module_id"
    t.integer "course_id"
    t.string "school_year"
    t.boolean "specialite", default: false
    t.integer "batch_id"
    t.index ["school_field_id"], name: "school_field_id"
    t.index ["school_module_id"], name: "school_module_id"
  end

  create_table "school_fields", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description_file_path"
    t.date "start_date_accreditation"
    t.date "end_date_accreditation"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "employee_id"
    t.text "description"
    t.integer "field_root"
    t.integer "school_id"
    t.string "name_english"
    t.integer "parent_sf_id"
    t.string "code_diplome"
    t.string "code_next"
    t.string "COD_PER"
    t.string "LIB_DIP_ARB"
    t.string "TEM_OUV_DRT_SSO_DIP"
    t.string "TEM_COU_ACC_TRV_DIP"
    t.string "NBR_MAX_INSC_DEUG"
    t.string "LIC_DIP"
    t.string "LIB_DIP"
    t.string "LIC_DIP_ARB"
    t.string "COD_SDS"
    t.string "COD_ETB"
    t.string "COD_NIM"
    t.string "COD_CYC"
    t.string "COD_TPD_ETB"
    t.string "COD_NDI"
    t.string "COD_DIP"
    t.string "COD_VRS_VDI"
    t.string "COD_SIS_VDI"
    t.string "COD_LIC_VDI"
    t.string "LIC_VDI"
    t.boolean "is_active"
    t.index ["employee_id"], name: "employee_id"
  end

  create_table "school_mobilities", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name"
    t.string "city"
    t.text "Addres"
    t.string "pays"
    t.integer "number_places"
    t.text "Address"
  end

  create_table "school_mobilities_fields", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "name"
    t.text "description"
    t.text "link_desc"
    t.integer "school_mobility_id"
    t.string "intitule"
  end

  create_table "school_mobility_ids", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
  end

  create_table "school_mobility_students", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "school_mobility_id"
    t.integer "student_id"
    t.boolean "is_active"
    t.integer "mobility_id"
  end

  create_table "school_module_subjects", id: :integer, charset: "latin1", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.decimal "subject_weighting", precision: 7, scale: 2
    t.decimal "test_weighting", precision: 7, scale: 2
    t.decimal "exam_weighting", precision: 7, scale: 2
    t.integer "subject_group_id"
    t.integer "school_module_id"
    t.string "school_year", limit: 20
    t.index ["school_module_id"], name: "school_module_id"
    t.index ["subject_group_id"], name: "school_module_subjects_ibfk_1"
  end

  create_table "school_modules", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.integer "employee_id"
    t.integer "department_id"
    t.integer "module_type_id"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "school_id"
    t.string "name_english"
    t.boolean "old", default: false
    t.integer "school_field_id"
    t.boolean "is_active"
    t.index ["department_id"], name: "department_id"
    t.index ["module_type_id"], name: "module_type_id"
  end

  create_table "sms_settings", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "settings_key"
    t.boolean "is_enabled", default: false
  end

  create_table "student_categories", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "name"
    t.boolean "is_deleted", default: false, null: false
  end

  create_table "students", id: :integer, charset: "utf8mb3", force: :cascade do |t|
    t.string "admission_no"
    t.string "class_roll_no"
    t.date "admission_date"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.integer "batch_id"
    t.date "date_of_birth"
    t.string "gender"
    t.string "blood_group"
    t.string "birth_place"
    t.integer "nationality_id"
    t.string "language"
    t.string "religion"
    t.integer "student_category_id"
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.string "pin_code"
    t.integer "country_id"
    t.string "phone1"
    t.string "phone2"
    t.string "email"
    t.integer "immediate_contact_id"
    t.boolean "is_sms_enabled", default: true
    t.string "photo_file_name"
    t.string "photo_content_type"
    t.binary "photo_data", size: :medium
    t.string "status_description"
    t.boolean "is_active", default: true
    t.boolean "is_deleted", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "has_paid_fees", default: false
    t.integer "photo_file_size"
    t.integer "user_id"
    t.string "matricule", default: ""
    t.string "type_concours"
    t.string "rang_concours"
    t.string "nom_ar"
    t.string "prenom_ar"
    t.string "cin"
    t.date "cin_debut"
    t.string "cin_lieu"
    t.string "num_baccalaureat"
    t.string "lycee"
    t.string "ville_bac"
    t.string "pays_bac"
    t.string "type_bac"
    t.string "type_ens"
    t.string "annee_bac"
    t.string "mention_bac"
    t.boolean "bourse"
    t.string "bourse_org"
    t.boolean "contractuel"
    t.string "contrat_org"
    t.string "num_bourse_contrat"
    t.integer "nbre_freres"
    t.string "prob_sante"
    t.string "lieu_naissance_ar"
    t.string "section"
    t.integer "filiere"
    t.integer "ordre"
    t.string "group_lang"
    t.string "group_td"
    t.integer "school_id"
    t.decimal "credits", precision: 7, scale: 2, default: "0.0"
    t.integer "resto_current_times"
    t.date "last_meal_time"
    t.string "current_rfid"
    t.boolean "allowed_to_resto"
    t.string "nation"
    t.string "nationalite"
    t.string "rib"
    t.boolean "co_amo"
    t.boolean "co_mut"
    t.string "email_inst"
    t.boolean "cnss"
    t.boolean "assurance"
    t.string "father_full_name"
    t.string "mother_full_name"
    t.string "father_job"
    t.string "father_cin"
    t.string "mother_job"
    t.string "mother_cin"
    t.boolean "is_edited"
    t.date "resto_start_date"
    t.date "resto_end_date"
    t.string "type_registration"
    t.string "code_massar"
    t.string "COD_IND"
    t.string "position"
    t.integer "note_so"
    t.integer "note_pfa"
    t.integer "note_pfe"
    t.string "apogee", limit: 20
    t.string "province_bac", limit: 100
    t.string "diplome_admission", limit: 100
    t.string "filiere_diplome", limit: 100
    t.string "code_cnc", limit: 100
    t.string "annee_diplome", limit: 100
    t.string "etablissement_dip", limit: 100
    t.string "ville_dip", limit: 100
    t.string "centre_dip", limit: 100
    t.string "type_enseignement", limit: 100
    t.string "pays_enseignement", limit: 100
    t.text "cv_content_type", size: :medium
    t.boolean "is_admission_valid"
    t.boolean "step_1"
    t.index ["admission_no"], name: "index_students_on_admission_no", length: 10
    t.index ["batch_id"], name: "index_students_on_batch_id"
    t.index ["first_name", "middle_name", "last_name"], name: "index_students_on_first_name_and_middle_name_and_last_name", length: 10
  end

  create_table "users", id: :integer, charset: "latin1", force: :cascade do |t|
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.boolean "admin"
    t.boolean "student"
    t.boolean "employee"
    t.string "hashed_password"
    t.string "salt"
    t.string "reset_password_code"
    t.datetime "reset_password_code_until", precision: nil
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.boolean "parent"
    t.integer "srvg"
    t.integer "cycle_id"
    t.boolean "is_dp"
    t.integer "school_id"
    t.string "token"
    t.string "password_digest"
    t.string "user_type"
    t.index ["username"], name: "index_users_on_username", length: 10
  end

  add_foreign_key "school_field_school_modules", "school_fields", name: "school_field_school_modules_ibfk_1"
  add_foreign_key "school_field_school_modules", "school_modules", name: "school_field_school_modules_ibfk_2"
  add_foreign_key "school_fields", "employees", name: "school_fields_ibfk_1"
  add_foreign_key "school_module_subjects", "school_modules", name: "school_module_subjects_ibfk_2"
  add_foreign_key "school_module_subjects", "subject_groups", name: "school_module_subjects_ibfk_1"
  add_foreign_key "school_modules", "employee_departments", column: "department_id", name: "school_modules_ibfk_1"
  add_foreign_key "school_modules", "module_types", name: "school_modules_ibfk_2"
end

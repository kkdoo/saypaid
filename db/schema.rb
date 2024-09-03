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

ActiveRecord::Schema[7.2].define(version: 2024_09_03_114607) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "default_currency_id", limit: 5, null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_accounts_on_discarded_at"
  end

  create_table "currencies", id: { type: :string, limit: 5 }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "layer_id", null: false
    t.string "name"
    t.string "email"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_customers_on_discarded_at"
  end

  create_table "layers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.boolean "livemode", default: false, null: false
    t.string "status", default: "draft", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.index ["discarded_at"], name: "index_layers_on_discarded_at"
  end

  create_table "plan_versions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "plan_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "layer_id", null: false
    t.string "name"
    t.string "code", null: false
    t.integer "interval", null: false
    t.integer "interval_count", null: false
    t.string "currency_id", limit: 5, null: false
    t.uuid "current_version_id", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_plans_on_discarded_at"
  end

  create_table "prices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "plan_version_id", null: false
    t.string "type", null: false
    t.decimal "flat_fee", precision: 20, scale: 5, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pricing_card_features", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "pricing_card_id", null: false
    t.string "name", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_pricing_card_features_on_discarded_at"
  end

  create_table "pricing_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "pricing_table_id", null: false
    t.uuid "plan_id", null: false
    t.integer "trial_in_days", default: 0
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_pricing_cards_on_discarded_at"
  end

  create_table "pricing_tables", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "layer_id", null: false
    t.string "code", null: false
    t.string "name"
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_pricing_tables_on_discarded_at"
  end

  create_table "subscription_versions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "subscription_id", null: false
    t.uuid "plan_version_id", null: false
    t.datetime "current_period_start", null: false
    t.datetime "current_period_end", null: false
    t.datetime "cancelation_time"
    t.datetime "terminate_at"
    t.datetime "start_at", null: false
    t.datetime "trial_end"
    t.integer "quantity", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "layer_id", null: false
    t.uuid "customer_id", null: false
    t.uuid "current_version_id", null: false
    t.integer "status", default: 0, null: false
    t.boolean "pay_in_advance", null: false
    t.datetime "discarded_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discarded_at"], name: "index_subscriptions_on_discarded_at"
  end
end

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

ActiveRecord::Schema.define(version: 2022_04_22_123656) do

  create_table "applications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "app_token", null: false
    t.string "app_name", null: false
    t.integer "chats_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_token"], name: "index_applications_on_app_token"
  end

  create_table "chats", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "chat_number", null: false
    t.string "app_token_fk", null: false
    t.integer "messages_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_token_fk"], name: "index_chats_on_app_token_fk"
    t.index ["chat_number", "app_token_fk"], name: "index_chats_on_chat_number_and_app_token_fk"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "message_content"
    t.integer "message_number", null: false
    t.integer "chat_number_fk", null: false
    t.string "app_token_fk", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_token_fk", "chat_number_fk", "message_number"], name: "index_on_token_chat_number_message_number", unique: true
    t.index ["chat_number_fk"], name: "fk_rails_6149d3c19d"
  end

  add_foreign_key "chats", "applications", column: "app_token_fk", primary_key: "app_token", on_delete: :cascade
  add_foreign_key "messages", "applications", column: "app_token_fk", primary_key: "app_token", on_delete: :cascade
  add_foreign_key "messages", "chats", column: "chat_number_fk", primary_key: "chat_number", on_delete: :cascade
end

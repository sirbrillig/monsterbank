# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121112061156) do

  create_table "monsters", :force => true do |t|
    t.string   "name"
    t.integer  "level"
    t.string   "role"
    t.string   "subrole"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "str"
    t.integer  "con"
    t.integer  "dex"
    t.integer  "int"
    t.integer  "wis"
    t.integer  "cha"
    t.string   "high_ability"
    t.boolean  "starred"
    t.integer  "user_id"
  end

  create_table "monsters_tags", :id => false, :force => true do |t|
    t.integer "monster_id"
    t.integer "tag_id"
  end

  add_index "monsters_tags", ["monster_id", "tag_id"], :name => "index_monsters_tags_on_monster_id_and_tag_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end

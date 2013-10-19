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

ActiveRecord::Schema.define(:version => 20131019113940) do

  create_table "cloud_providers", :force => true do |t|
    t.string   "key"
    t.string   "name"
    t.string   "provider"
    t.string   "secret"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
  end

  create_table "instances", :force => true do |t|
    t.string   "title"
    t.string   "instance_id"
    t.string   "state"
    t.string   "flavor_id"
    t.string   "name"
    t.string   "private_ip"
    t.string   "public_ip"
    t.string   "cloud_provider_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "guest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end

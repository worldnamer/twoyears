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

ActiveRecord::Schema.define(:version => 20131119015722) do

  create_table "commits", :force => true do |t|
    t.string   "commit_hash"
    t.datetime "committed_at"
    t.text     "message",      :limit => 255
    t.string   "repository"
  end

  add_index "commits", ["commit_hash"], :name => "index_commits_on_commit_hash"
  add_index "commits", ["committed_at"], :name => "index_commits_on_committed_at"

  create_table "commits_tags", :force => true do |t|
    t.integer "commit_id"
    t.integer "tag_id"
  end

  add_index "commits_tags", ["commit_id", "tag_id"], :name => "index_commits_tags_on_commit_id_and_tag_id"
  add_index "commits_tags", ["tag_id", "commit_id"], :name => "index_commits_tags_on_tag_id_and_commit_id"

  create_table "tags", :force => true do |t|
    t.string "text"
  end

  add_index "tags", ["text"], :name => "index_tags_on_text"

end

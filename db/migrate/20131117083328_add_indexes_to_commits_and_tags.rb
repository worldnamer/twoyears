class AddIndexesToCommitsAndTags < ActiveRecord::Migration
  def change
    add_index :commits, :committed_at
    add_index :commits, :commit_hash
    add_index :commits_tags, [:commit_id, :tag_id]
    add_index :commits_tags, [:tag_id, :commit_id]
    add_index :tags, :text
  end
end

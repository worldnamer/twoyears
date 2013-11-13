class AddTagsToCommits < ActiveRecord::Migration
  def change
    add_column :commits, :tags, :text
  end
end

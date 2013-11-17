class ConvertTagsToFlyweight < ActiveRecord::Migration
  def up
    create_table :commits_tags do |t|
      t.belongs_to :commit
      t.belongs_to :tag
    end

    Tag.class_eval do
      belongs_to :old_commit,
                 :class_name => "Commit",
                 :foreign_key => "commit_id"
    end

    tag_texts = Tag.select("distinct text")

    tag_texts.each do |tag_text|
      tags = Tag.where(text: tag_text.text)
      commits = []
      tags.each do |tag|
        commits << tag.old_commit
        tag.destroy
      end
      new_tag = Tag.create(text: tag_text.text, commits: commits)
    end

    remove_column :tags, :commit_id
  end

  def down
    add_column :tags, :commit_id, :integer

    Tag.class_eval do
      belongs_to :new_commit,
                 :class_name => "Commit",
                 :foreign_key => "commit_id"
    end

    Tag.all.each do |tag|
      commits = []
      tag.commits.each do |commit|
        commits << commit
      end
      tag_text = tag.text
      tag.destroy
      commits.each do |commit|
        tag = Tag.create
        tag.text = tag_text
        tag.new_commit = commit
        tag.save
      end
    end

    drop_table :commits_tags
  end
end

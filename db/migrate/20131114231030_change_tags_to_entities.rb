class ChangeTagsToEntities < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.references :commit

      t.string :text
    end

    remove_column :commits, :tags
  end
end

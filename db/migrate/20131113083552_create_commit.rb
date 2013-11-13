class CreateCommit < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :commit_hash
      t.datetime :committed_at
      t.string :message
    end
  end
end

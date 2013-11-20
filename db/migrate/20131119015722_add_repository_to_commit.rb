class AddRepositoryToCommit < ActiveRecord::Migration
  def change
    add_column :commits, :repository, :string

    Commit.update_all repository: 'pats'
  end
end

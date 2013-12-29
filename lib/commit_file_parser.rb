require 'csv'

class CommitFileParser
  def parse(filename)
    CSV.foreach(filename, headers: true) do |row|
      repository = row[0]
      commit_hash = row[1]
      committed_at = row[2]
      message = row[3]
      tags = (row[4] || "").split(",")

      user = User.first
      commit = Commit.create(repository: repository, commit_hash: commit_hash, committed_at: committed_at, message: message, user: user)
      tags.each do |tag_text|
        tag = Tag.where(text:tag_text).first
        if tag
          commit.tags << tag
        else
          commit.tags << Tag.create(text: tag_text)
        end
        commit.save
      end
    end
  end
end
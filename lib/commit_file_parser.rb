require 'csv'

class CommitFileParser
  def parse(filename)
    CSV.foreach(filename, headers: true) do |row|
      commit_hash = row[0]
      committed_at = row[1]
      message = row[2]
      tags = row[3].split(",")

      commit = Commit.create(commit_hash: commit_hash, committed_at: committed_at, message: message)
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
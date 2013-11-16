require 'csv'

class CommitFileParser
  def parse(filename)
    CSV.foreach(filename, headers: true) do |row|
      commit_hash = row[0]
      committed_at = row[1]
      message = row[2]
      tags = row[3].split(",")

      commit = Commit.create(commit_hash: commit_hash, committed_at: committed_at, message: message)
      tags.each do |tag|
        commit.tags << Tag.create(text: tag)
      end
    end
  end
end
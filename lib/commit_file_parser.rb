class CommitFileParser
  def parse(filename)
    File.readlines(filename).each do |line|
      commit_hash = line[0,7]
      committed_at = Time.parse(line[9, 37])
      message = line[39, line.length-40]
      Commit.create(commit_hash: commit_hash, committed_at: committed_at, message: message)
    end
  end
end
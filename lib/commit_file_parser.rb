class CommitFileParser
  def parse(filename)
    File.readlines(filename).each do |line|
      hash_start = line.index(' ')+1
      commit_hash = line[0,hash_start-1]

      message_starts_at = line.index('0700')+4+1 if line.index('0700')
      message_starts_at = line.index('0600')+4+1 if line.index('0600')
      message_starts_at = line.index('0000')+4+1 if line.index('0000') and not message_starts_at

      committed_at = DateTime.strptime(line[hash_start,message_starts_at-hash_start-1], '%a %b %d %H:%M:%S %Y %z')

      message = line[message_starts_at, line.length-message_starts_at-1]
      Commit.create(commit_hash: commit_hash, committed_at: committed_at, message: message)
    end
  end
end
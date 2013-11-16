puts "seeding database"
CommitFileParser.new.parse('db/commits.csv')
puts "finished"
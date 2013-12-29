puts "seeding database"
puts "creating user"
User.create(email: 'worldnamer@worldnamer.com', password: 'password', password_confirmation: 'password')
puts "loading commits"
CommitFileParser.new.parse('db/commits.csv')
puts "finished"
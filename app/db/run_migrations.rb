%w(rubygems yaml pg activerecord).each do |lib| require lib end

puts 'Starting Migrations'
load 'db_connect.rb'

ActiveRecord::Base.colorize_logging = false
logFile = File.open("database.log", "w") 
ActiveRecord::Base.logger = Logger.new(logFile)

puts "ABOUT TO RUN MIGRATIONS"
#ActiveRecord::Migrator.migrate("migrations")

ActiveRecord::Migrator.migrate("migrations", ENV["VERSION"] ? ENV["VERSION"].to_i : nil )
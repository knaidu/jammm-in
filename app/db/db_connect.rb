%w(rubygems yaml pg activerecord).each do |lib| require lib end
  
dbconfig = YAML::load(File.open("../config/database.yml"))["dev"]

puts "DBCONFIG: #{dbconfig.inspect}"
conn = ActiveRecord::Base.establish_connection(dbconfig)
puts "DB CONNECTION: #{conn.inspect}"
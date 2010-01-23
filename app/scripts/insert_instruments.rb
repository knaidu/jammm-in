ROOT = ENV["WEBSERVER_ROOT"]

load "#{ROOT}/scripts/load_needed.rb"

instruments_list = IO.read("#{ROOT}/config/instruments.list").split("\n")
puts instruments_list
#exit

# Inserts all te instruments
instruments_list.each do |instrument|
  puts "Instrument name: #{instrument}"
  Instrument.create(:name => instrument)
end

# Deletes the instruments not listed in the file
Instrument.all.each do |instrument|
  instrument.destroy if not instruments_list.include?(instrument.name)
end
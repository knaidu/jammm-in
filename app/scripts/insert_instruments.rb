ROOT = ENV["WEBSERVER_ROOT"]

load "#{ROOT}/scripts/load_needed.rb"

instruments_list = IO.read("#{ROOT}/config/instruments.list").split("\n")
puts instruments_list
instruments_data = instruments_list.map{|i| i.split(",")}
#puts instruments_data.inspect
instruments_names = instruments_data.map{|i| i[0]}.map(&:strip)
puts instruments_names.inspect
#exit

# Inserts all te instruments
instruments_list.each do |instrument|
  name = instrument.split(",").map(&:strip)[0]
  puts "Instrument name: #{name}"
  i = Instrument.create(:name => name)
  puts i.inspect
end

puts ""
puts "======"
puts "begining the deletion process"
# Deletes the instruments not listed in the file
Instrument.all.each do |instrument|
  if not instruments_names.include?(instrument.name)
#    puts "FOUND #{instrument.inspect}"
    instrument.destroy 
  end
end

instruments_list.each {|instrument|
  name, image = instrument.split(",").map{|i| i ? i.strip : nil} 
  begin
    i = Instrument.named(name)
    puts i.inspect
    i.image_url = image if image
    i.save
  rescue
    puts "skipping: #{name.to_s}"
  ensure
    puts "---"
  end
  
}
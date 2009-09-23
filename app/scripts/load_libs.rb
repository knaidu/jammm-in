
app_root = ENV['WEBSERVER_ROOT']
libs = `ls #{app_root}/lib`.split("\n")
puts 'libs are: ' + libs.inspect
libs.each do |lib| require "#{app_root}/lib/#{lib}" end

# Include List

[Utils].each do |lib| include lib end
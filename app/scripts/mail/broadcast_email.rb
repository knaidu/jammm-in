require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

Daemons.daemonize # Runs the script in the background

options = argv_options


cron_log_new_section("BROADCASTING EMAIL")  

body = IO.read(options[:file])
File.delete(options[:file])

puts body
puts options.inspect

MAIL_DETAILS = {
  :from => "support@jammm.in",
  :password => "3WiseMen",
  :subject => options[:subject],
  :body => body
  #:to => user.email
}

User.all.each do |user|
  cron_log("Sending mail to #{user.username} : #{user.email}")
  mail MAIL_DETAILS.clone.update({:to => user.email})  
end


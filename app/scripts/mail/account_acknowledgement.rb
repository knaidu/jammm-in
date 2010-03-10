puts ENV["USER"]

File.open("/home/jammmin/acc.log", "a+"){|file| file.puts ENV.inspect}

require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

cron_log_new_section("SENDING ACCOUNT ACKNOWLEDGEMENT EMAIL")
Daemons.daemonize # Runs the script in the background

user_id = ARGV[0]
user = User.find(user_id)
 
MAIL_DETAILS = {
  :from => "support@jammm.in",
  :password => "3WiseMen",
  :subject => "Successfully created a jamMm.in account",
  :body => get_localhost_response("/partial/mail/acknowledgement")
}


mail MAIL_DETAILS.clone.update({:to => user.email})

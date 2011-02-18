log = File.new("/home/jammmin/log/sinatra.log", "a")
STDOUT.reopen(log)
STDERR.reopen(log)

File.open("/home/jammmin/acc.log", "a+"){|file| file.puts ENV.inspect}

require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

cron_log_new_section("SENDING FOR EMAIL FORGOT PASSWORD")

user_id = ARGV[0]
user = User.find(user_id.to_i)

password = ARGV[1]

MAIL_DETAILS = {
  :from => "support@jammm.in",
  :password => "3WiseMen",
  :subject => "jamMm.in password reset",
  :body => get_localhost_response("/partial/mail/forgot_password?password=#{password}&username=#{user.username}")
}

mail MAIL_DETAILS.clone.update({:to => user.email})

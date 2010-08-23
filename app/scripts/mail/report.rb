require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

Daemons.daemonize # Runs the script in the background

options = argv_options
puts options.inspect

body = "#{options[:music_type].capitalize} (id: #{options[:music_id]}) has been reported"
body += " by user id #{options[:user_id]}" if options[:user_id]
puts body

REPORT_DETAILS = {
  :from => "support@jammm.in",
  :password => "3WiseMen",
  :subject => "MUSIC REPORTED",
  :body => body
}

mail_to = (["prakashraman@jammm.in", "tarunrs@jammm.in"]).compact.uniq

mail REPORT_DETAILS.clone.update({:to => mail_to.join(",")})
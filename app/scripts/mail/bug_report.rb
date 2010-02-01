require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

Daemons.daemonize # Runs the script in the background

bug_id = ARGV[0]
bug = Bug.find(bug_id)

BUG_MAIL_DETAILS = {
  :from => "support@jammm.in",
  :password => "3WiseMen",
  :subject => "BUG REPORT - #{bug.subject}",
  :body => bug.description.message
}

mail BUG_MAIL_DETAILS.clone.update({:to => "prakash.raman.ka@gmail.com"})
mail BUG_MAIL_DETAILS.clone.update({:to => "tarun@jammm.in"})
require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

puts "Running Invite Script in background"
Daemons.daemonize # Runs the script in the background

options = argv_options

invite = Invite.find(options[:invite_id])

BUG_MAIL_DETAILS = {
  :from => "invite@jammm.in",
  :password => "3WiseMen",
  :subject => "jamMmin Invite",
  :body => get_localhost_response("/partial/mail/invite?invite_id=#{invite.id}")
}

mail BUG_MAIL_DETAILS.clone.update({:to => invite.invitee_email_id})


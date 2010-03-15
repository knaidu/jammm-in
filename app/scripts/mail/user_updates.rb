require "#{ENV["WEBSERVER_ROOT"]}/scripts/load_needed.rb"
require 'daemons'

cron_log_new_section("SENDING USER UPDATES")
Daemons.daemonize # Runs the script in the background


User.all.each do |user|
  cron_log_new_section("USER: #{user.username}")  
  cron_log("Determining to send to update to #{user.username}")
  
  if (user.last_sent_update_at.nil?) or ((Time.now - user.last_sent_update_at) < 1.day.to_i)
    cron_log("Not sending update as last update was sent lesser than a day ago.")
    next
  end
  
  if not user.send_user_update?(Time.now - (1.day.to_i))
    cron_log("There are no notifications to be send to #{user.username}")
    next
  end 
  
  cron_log("Sending email update")
  update_mail_details = {
    :from => "support@jammm.in",
    :password => "3WiseMen",
    :subject => "Updates",
    :body => get_localhost_response("/partial/mail/user_update?user_id=#{user.id}"),
    :to => user.email
  }
  mail(update_mail_details)
  user.last_sent_update_at = Time.now
  user.save
end





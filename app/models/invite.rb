class Invite < ActiveRecord::Base

  belongs_to :referrer, :class_name => "User", :foreign_key => "referred_user_id", :primary_key => "id"

  def self.add(invitee_email_id, referred_user=nil)
    invite = self.create({
      :referred_user_id => (referred_user ? referred_user.id : nil),
      :invitee_email_id => invitee_email_id
    })
    invite.mail_invite
    invite
  end
  
  def code
    md5("invite:#{self.invitee_email_id}") + ";#{self.id.to_s}"
  end
  
  def mail_invite
    cmd = "ruby #{ENV["WEBSERVER_ROOT"]}/scripts/mail/invite.rb --invite_id=#{self.id}"
    run(cmd)
  end

end
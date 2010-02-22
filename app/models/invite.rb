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
    md5("invite:#{self.invitee_email_id}") + "-#{self.id.to_s}"
  end
  
  def mail_invite
    cmd = "ruby #{ENV["WEBSERVER_ROOT"]}/scripts/mail/invite.rb --invite_id=#{self.id}"
    run(cmd)
  end

  def self.extract_invite(code)
    msg = "Sorry the invite code does not seem to match in our system"
    arr = code.split("-")
    invite = Invite.find(arr[1])
    raise msg if not invite.code == code
    msg = "Sorry could not complete the registration as it seems that this invite has already been used."
    raise msg if invite.status == 'used'
    invite
  rescue
    raise msg
  end
  
  def mark_as_used
    self.status = 'used'
    self.save
  end
  
end

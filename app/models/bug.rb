class Bug < ActiveRecord::Base
  has_many :bugs_bodies, :dependent => :destroy, :class_name => "BugBody", :order => "created_at"
  before_create {|record| 
    record.created_at = Time.now
    record.status = "open"
  }
  
  alias messages bugs_bodies
  
  def self.add(subject, message=nil)
    bug = self.create(:subject => subject)
    bug.add_message(message) if message
    bug.mail_bug_report
    bug
  end
  
  def add_message(message)
    BugBody.add(self, message)
  end
  
  def self.list 
    Bug.find(:all, :order => "created_at DESC")
  end
  
  def description
    bugs_bodies[0] if not bugs_bodies.empty?
  end
  
  def mark_status(bug_status)
    self.status = bug_status
    self.save
  end
  
  def mail_bug_report
    cmd = "ruby #{ENV["WEBSERVER_ROOT"]}/scripts/mail/bug_report.rb #{self.id}"
    run(cmd)
  end
  
end
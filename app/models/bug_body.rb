class BugBody < ActiveRecord::Base
  belongs_to :bug
  set_table_name :bugs_body
  belongs_to :user
  before_create {|record| record.created_at = Time.now}
  
  def self.add(bug, message, user=nil)
    self.create(:bug_id => bug.id, :message => message, :user_id => (user.id rescue nil))
  end
end
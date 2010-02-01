class BugBody < ActiveRecord::Base
  belongs_to :bug
  set_table_name :bugs_body
  before_create {|record| record.created_at = Time.now}
  
  def self.add(bug, message)
    self.create(:bug_id => bug.id, :message => message)
  end
end
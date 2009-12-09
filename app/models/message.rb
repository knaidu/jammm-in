class Message < ActiveRecord::Base
  belongs_to :from, :class_name => "User", :foreign_key => "from_id"
  belongs_to :to, :class_name => "User", :foreign_key => "to_id"
  
  def self.add(from, to, subject, body)
    self.create({
      :from_id => from.id,
      :to_id => to.id,
      :subject => subject,
      :body => body,
      :created_at => Time.now
    })
  end
  
end
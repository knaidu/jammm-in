class UserMessageStream < ActiveRecord::Base
  
  belongs_to :message_stream
  belongs_to :user
  
  def self.add(user, message_stream, body)
    self.create({
      :user_id => user.id,
      :message_stream_id => message_stream.id,
      :body => body,
      :created_at => Time.now
    })
  end
  
  def mark_as_read
    self.unread = false
    self.save
  end
  
end

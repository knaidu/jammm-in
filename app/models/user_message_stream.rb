class UserMessageStream < ActiveRecord::Base
  
  belongs_to :message_stream
  belongs_to :user
  
  def self.add(user, message_stream, body)
    ums = self.create({
      :user_id => user.id,
      :message_stream_id => message_stream.id,
      :body => body,
      :created_at => Time.now
    })
    ums.send_notification
    ums
  end
  
  def send_notification
    other_user = (self.message_stream.users - [self.user])[0]
    notification = Notification.add({
      :users_ids => [user.id, other_user.id],
      :"message_id" => self.id
    }, "new_message")
    notification.add_users([other_user])
  end
  
  def mark_as_read
    self.unread = false
    self.save
  end
  
end

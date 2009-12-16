class MessageStream < ActiveRecord::Base
  
  has_many :user_message_stream_maps, :dependent => :destroy
  has_many :users, :through => :user_message_stream_maps  
  has_many :user_message_streams, :dependent => :destroy
  
  alias messages user_message_streams

  def self.find_stream(user_1, user_2)
    puts  [user_1, user_2].inspect
    self.all.find do |message_stream|
      message_stream.users.sort_by(&:id) == [user_1, user_2].sort_by(&:id)
    end
  end
  
  def self.start(users)
    message_stream = self.find_stream(users[0], users[1])
    return message_stream if message_stream
    
    message_stream = self.create
    users.each do |user| UserMessageStreamMap.add(message_stream, user) end
    message_stream
  end
  
  def add_message(user, body)
    UserMessageStream.add(user, self, body)
  end
  
  def mark_as_read
    self.messages.each(&:mark_as_read)
  end
  
end

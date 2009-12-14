class UserMessageStreamMap < ActiveRecord::Base
  
  belongs_to :message_stream
  belongs_to :user
  validates_uniqueness_of :user_id, :scope => [:message_stream_id]
  
  def self.add(message_stream, user)
    self.create({
      :message_stream_id => message_stream.id,
      :user_id => user.id
    })
  end
  
end
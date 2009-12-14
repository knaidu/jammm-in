class Message < ActiveRecord::Base

  belongs_to :user_message_map
  
  def self.add(user_message_map_id, body)
    self.create({
      :user_message_map_id => user_message_map_id.id,
      :body => body,
      :created_at => Time.now
    })
  end
  
end
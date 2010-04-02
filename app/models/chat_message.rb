class ChatMessage < ActiveRecord::Base
  belongs_to :chat_user
  belongs_to :user
  
  def self.add(user, message)
    self.create({
      :user_id => user.id,
      :message => message,
      :created_at => Time.now
    })
  end
  
  def self.fetch
    self.find(:all, :order => "id ASC", :limit => 100)
  end
  
end
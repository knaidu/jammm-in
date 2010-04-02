class ChatMessage < ActiveRecord::Base
  belongs_to :chat_user
  belongs_to :user
  
  def self.add(user, message, automated=false)
    self.create({
      :user_id => user.id,
      :message => message,
      :automated => automated,
      :created_at => Time.now
    })
  end
  
  def self.fetch
    self.find(:all, :order => "id ASC", :limit => 100)
  end
  
end
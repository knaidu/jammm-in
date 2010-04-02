class ChatUser < ActiveRecord::Base
  has_many :chat_messages, :foreign_key => :user_id, :primary_key => :user_id
  belongs_to :user
  validates_uniqueness_of :user_id
  
  def self.sign_in(user)
    self.find_by_user_id(user.id).destroy if self.find_by_user_id(user.id)
    ChatUser.create({
      :user_id => user.id,
      :signed_in_at => Time.now,
      :last_ping_at => Time.at(0)
    })
  end
  
  def sign_out
    self.destroy rescue nil
    ChatMessage.destroy_all if ChatUser.all.empty?
  end
  
  def say(message)
    ChatMessage.add(self.user, message)
  end
  
  def self.users
    ChatUser.all.map(&:user)
  end
  
end
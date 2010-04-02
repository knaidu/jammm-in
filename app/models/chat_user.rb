class ChatUser < ActiveRecord::Base
  has_many :chat_messages, :foreign_key => :user_id, :primary_key => :user_id
  belongs_to :user
  validates_uniqueness_of :user_id
  
  def self.sign_in(user)
    self.find_by_user_id(user.id).destroy if self.find_by_user_id(user.id)
    chat_user = ChatUser.create({
      :user_id => user.id,
      :signed_in_at => Time.now,
      :last_ping_at => Time.at(0)
    })
    chat_user.say("has signed into chat.", true)
    chat_user.pinged
    self.check_list
  end
  
  def sign_out
    say("has signed out of the chat.", true)
    self.destroy rescue nil
    ChatMessage.destroy_all if ChatUser.all.empty?
    self.class.check_list
  end
  
  def say(message, automated=false)
    ChatMessage.add(self.user, message, automated)
  end
  
  def self.users
    ChatUser.all.map(&:user)
  end
  
  def pinged
    self.last_ping_at = (Time.now)
    self.save
  end
  
  def new_users?
    true unless (self.class.find(:all, :conditions => ["signed_in_at > '#{self.last_ping_at}'"]) - [self]).empty?
  end
  
  def new_messages?
    messages = ChatMessage.find(:all, :conditions => ["created_at > '#{self.last_ping_at}'"])
    messages.sort_by(&:id)
    messages.empty? ? false : messages
  end
  
  def self.check_list
    time = Time.now
    self.all.each {|chat_user|
      chat_user.destroy if  (time - chat_user.last_ping_at) > 200
    }
  end
  
end
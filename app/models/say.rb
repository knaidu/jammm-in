class Say < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :message
  
  belongs_to :user
  
  def self.add(user, message)
    say = self.create({
      :user_id => user.id,
      :message => message,
      :created_at => Time.now
    })
    say.add_feed
    say
  end
  
  def add_feed
    feed = Feed.add({:user_ids => [self.user.id], :"say_id" => self.id}, "say", "public")
    feed.add_users([self.user])
  end
  
end
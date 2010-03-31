class Follower < ActiveRecord::Base

  belongs_to :follows, :class_name => "User", :primary_key => 'id', :foreign_key => 'follows_user_id'
  belongs_to :followed_by, :class_name => "User", :primary_key => 'id', :foreign_key => 'user_id'
  validates_uniqueness_of :user_id, :scope => [:follows_user_id]
  
  def before_create
    raise "You will get dizzy if you follow yourself" if user_id == follows_user_id
    true
  end
  
  def self.add(user, follows_user)
    return if self.find_by_user_id_and_follows_user_id(user.id, follows_user.id) # Does not allow duplicate entries to go through
    row = self.create({:user_id => user.id, :follows_user_id => follows_user.id})
    feed = Feed.add({:user_ids => [user.id, follows_user.id]}, "user_follows")
    feed.add_users([user])
    row.send_notification
    row
  end
  
  def send_notification
    notification = Notification.add({:follower_id => self.id}, "user_follows")
    notification.add_users([self.follows])
  end
  
  def self.remove(user, follows_user)
    follower = self.find_by_user_id_and_follows_user_id(user.id, follows_user.id).destroy
    Notification.delete_by_data("follower_id", follower.id)
  rescue
    true
  end
  
end

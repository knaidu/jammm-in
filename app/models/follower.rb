class Follower < ActiveRecord::Base

  belongs_to :follows, :class_name => "User", :primary_key => 'id', :foreign_key => 'follows_user_id'
  belongs_to :followed_by, :class_name => "User", :primary_key => 'id', :foreign_key => 'user_id'
  
  def before_create
    raise "You will get dizzy if you follow yourself" if user_id == follows_user_id
    true
  end
  
  def self.add(user, follows_user)
    row = self.create({:user_id => user.id, :follows_user_id => follows_user.id})
    feed = Feed.add({:user_ids => [user.id, follows_user.id]}, "user_follows")
    feed.add_users([user, follows_user])
    row
  end
  
  def self.remove(user, follows_user)
    self.find_by_user_id_and_follows_user_id(user.id, follows_user.id).destroy
  end
  
end

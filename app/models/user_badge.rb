class UserBadge < ActiveRecord::Base
  validates_uniqueness_of :user_id, :scope => :badge_id
  belongs_to :user
  
  before_save {|record| record.created_at = Time.now}
  
  after_create after_create
  
  def after_create
    add_feed
    add_notification
  end
  
  def add_feed
    feed = Feed.add({:user_ids => [self.user.id], :badge_id => self.badge.id}, "badge_added", "public")
    feed.add_users([self.user])
  end
  
  def add_notification
    notification = Notification.add({:badge_id => self.badge.id}, "badge_added")
    notification.add_users([self.user])
  end

  def badge
    Badge.new(badge_id)
  end
  
end

class Feed < ActiveRecord::Base
  
  before_save {|record| record.created_at = Time.now}
  has_many :user_feeds, :dependent => :destroy
  has_many :users, :through => :user_feeds
  
  def self.add(data={}, feed_type="update")
    self.create({:data => data.to_json, :feed_type => feed_type})
  end
  
  def add_users(users)
    users.each {|user|
      UserFeed.create({:user_id => user.id, :feed_id => self.id})
    }
  end
  
  def set_global
    UserFeed.create({:user_id => 0, :feed_id => self.id})
  end
  
  
end
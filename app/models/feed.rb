# Feed.scope
# ==========
# global : Feeds related to only Jammm.in
# public : User's feeds Visible by all 
# private : Feeds related to only Feed.users
# protected : Visible to only Followers

class Feed < ActiveRecord::Base
  
  before_save {|record| record.created_at = Time.now}
  has_many :user_feeds, :dependent => :destroy
  has_many :users, :through => :user_feeds
  
  def self.add(data={}, feed_type="update", scope="public")
    self.create({:data_str => data.to_json, :feed_type => feed_type, :scope => scope})
  end
  
  def add_users(users)
    users.each {|user|
      UserFeed.create({:user_id => user.id, :feed_id => self.id})
    }
  end
  
  def set_global
    UserFeed.create({:user_id => 0, :feed_id => self.id})
  end
  
  def data
    self.data_str.eval_json rescue nil
  end
  
  def self.global
    self.find_all_by_scope("global").reverse
  end
  
end
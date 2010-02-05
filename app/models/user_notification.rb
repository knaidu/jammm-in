class UserFeed < ActiveRecord::Base
  validates_uniqueness_of :user_id, :scope => :feed_id
  belongs_to :user
  belongs_to :feed
  
end
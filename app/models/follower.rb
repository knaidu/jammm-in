class Follower < ActiveRecord::Base

  has_one :follows, :class_name => "User", :primary_key => 'follows_user_id', :foreign_key => 'id'
  has_one :followed_by, :class_name => "User", :primary_key => 'user_id', :foreign_key => 'id'
  
end

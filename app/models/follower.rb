class Follower < ActiveRecord::Base

  belongs_to :follows, :class_name => "User", :primary_key => 'id', :foreign_key => 'follows_user_id'
  belongs_to :followed_by, :class_name => "User", :primary_key => 'id', :foreign_key => 'user_id'
  
end

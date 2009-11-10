class SongLike < ActiveRecord::Base
  belongs_to :song
  belongs_to :user
  validates_uniqueness_of :user_id, :scope => [:song_id]
  belongs_to :liked_by, :class_name => "User", :primary_key => "id", :foreign_key => "user_id" 
  
end

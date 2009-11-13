class SongLike < ActiveRecord::Base
  belongs_to :song
  belongs_to :user
  validates_uniqueness_of :user_id, :scope => [:song_id]
  belongs_to :liked_by, :class_name => "User", :primary_key => "id", :foreign_key => "user_id" 
  
  def self.add(song, user)
    self.create({:song_id => song.id, :user_id => user.id})
  end
  
  def self.remove(song, user)
    self.find_by_song_id_and_user_id(song.id, user.id).destroy
  end
  
end

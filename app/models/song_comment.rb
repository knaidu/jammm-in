class SongComment < ActiveRecord::Base
  belongs_to :song 
  belongs_to :jam
#  validate_uniquesness_of :user_id, :scope => [:song_id, :comment]

  def self.add(song, user, comment)
    
  end
end
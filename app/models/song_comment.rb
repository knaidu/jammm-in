class SongComment < ActiveRecord::Base
  belongs_to :song 
  belongs_to :user

  def self.add(song, user, comment)
    self.create({
      :song_id => song.id,
      :user_id => user.id,
      :comment => comment
    })    
  end
end
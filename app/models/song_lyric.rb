class SongLyric < ActiveRecord::Base
  belongs_to :song
  validates_uniqueness_of :song_id
  
  def self.add(user, song, lyrics)
    if(row = song.song_lyric)
      return row.append({:user_id => user.id, :lyrics => lyrics})
    end
    self.create({:user_id => user.id, :song_id => song.id, :lyrics => lyrics})
  end
end
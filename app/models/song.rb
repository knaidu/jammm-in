class Song < ActiveRecord::Base
  has_many  :song_artists
  
  def artists
    song_artists.map(&:artist)
  end
end

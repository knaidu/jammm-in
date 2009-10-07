class User < ActiveRecord::Base

  def songs
    SongArtist.find_all_by_artist_id(id).map(&:song)
  end

  def personal_info
    attributes
  end
  
end

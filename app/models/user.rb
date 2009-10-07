class User < ActiveRecord::Base
  has_many :songs, :through => :song_artists
  has_many :song_artists, :foreign_key => "artist_id"

  def personal_info
    attributes
  end
  
end

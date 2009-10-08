class User < ActiveRecord::Base

  has_many :jam_artists, :foreign_key => "artist_id"
  has_many :jams, :through => :jam_artists
  has_many :followers, :foreign_key => "follows_user_id"
  has_many :follows, :through => :followers
  has_many :followed_by, :through => :followers


  def collaborators
    artists = jams.map(&:artists).flatten.uniq.reject do |user| user == self end
  end

  def songs
    jams.map(&:song)
  end
  
  def personal_info
    attributes
  end
  
end

class User < ActiveRecord::Base

  has_many :jam_artists, :foreign_key => "artist_id"
  has_many :jams, :through => :jam_artists

  def personal_info
    attributes
  end
  
end

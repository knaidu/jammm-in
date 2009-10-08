class Jam < ActiveRecord::Base
  has_many :jam_artists
  has_many :artists, :through => :jam_artists
  has_one :song_jam, :foreign_key => "jam_id"
  has_one :song, :through => :song_jam

end

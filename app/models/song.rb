class Song < ActiveRecord::Base
  has_many :song_jams
  has_many :jams, :through => :song_jams

  def artists
    jams.map(&:artists).flatten
  end
  
end

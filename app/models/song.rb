class Song < ActiveRecord::Base
  has_many :song_jams
  has_many :jams, :through => :song_jams
  belongs_to :creator, :class_name => "User", :foreign_key => "registered_user_id"

  include SongUtils
  
  def artists
    jams.map(&:artists).flatten.uniq
  end
  
  
end

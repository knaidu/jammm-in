class Jam < ActiveRecord::Base
  has_many :jam_artists
  has_many :artists, :through => :jam_artists
  has_one :song_jam, :foreign_key => "jam_id"
  has_one :song, :through => :song_jam
  has_one :creator, :primary_key => 'registered_user_id', :foreign_key => 'id', :class_name => "User"

  include JamUtils

  def file
    File.open(ENV['FILES_DIR'] + "/" + file_handle) rescue nil
  end

end


class Jam < ActiveRecord::Base
  has_many :jam_artists, :dependent => :destroy
  has_many :artists, :through => :jam_artists
  has_one :song_jam, :foreign_key => "jam_id", :dependent => :destroy
  has_one :song, :through => :song_jam
  has_one :creator, :primary_key => 'registered_user_id', :foreign_key => 'id', :class_name => "User"
  has_one :published, :class_name => "PublishedJam", :dependent => :destroy
  
  after_destroy :delete_file_handle

  include JamUtils

  def file
    File.open(ENV['FILES_DIR'] + "/" + file_handle) rescue nil
  end
  
  def file_handle_exists?
    file_handle and File.exists(file_handle_path(self))
  end
  
  def delete_file_handle
    File.delete(file_handle_path(self))
  end
  
  def visited
    self.views ||= 0
    self.views += 1
    self.save
  end

end


class Jam < ActiveRecord::Base
  has_many :jam_artists, :dependent => :destroy
  has_many :artists, :through => :jam_artists
  has_one :song_jam, :foreign_key => "jam_id", :dependent => :destroy
  has_one :song, :through => :song_jam
  has_one :creator, :primary_key => 'registered_user_id', :foreign_key => 'id', :class_name => "User"
  has_one :published, :class_name => "PublishedJam", :dependent => :destroy
  has_many :jam_likes, :dependent => :destroy
  has_many :liked_by, :through => :jam_likes
  has_many :comments, :class_name => "JamComment"
  
  after_create {|jam| jam.tag_artist(jam.creator)}
  after_destroy :delete_file_handle

  include JamUtils

  def file
    File.open(ENV['FILES_DIR'] + "/" + file_handle) rescue nil
  end
  
  def file_handle_exists?
    file_handle and File.exists?(file_handle_path(self))
  end
  
  def delete_file_handle
    File.delete(file_handle_path(self)) if file_handle_exists?
  end
  
  def song_jam_active?
    song_jam.active rescue nil
  end
  
  def visited
    self.views ||= 0
    self.views += 1
    self.save
  end

  def publish
    jam = self.song ? self.make_copy_and_publish("#{self.name} (published)") : self # If jam part of a song, then a copy of the jam will be published 
    PublishedJam.add(jam)
  end

  def like(user)
    JamLike.add(self, user)
  end
  
  def unlike(user)
    JamLike.remove(self, user)
  end
  
  def comment(user, comment)
    JamComment.add(self, user, comment)
  end

end


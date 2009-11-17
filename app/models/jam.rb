class Jam < ActiveRecord::Base
  has_many :jam_artists, :dependent => :destroy
  has_many :artists, :through => :jam_artists
  has_one :song_jam, :foreign_key => "jam_id", :dependent => :destroy
  has_one :song, :through => :song_jam
  has_one :creator, :primary_key => 'registered_user_id', :foreign_key => 'id', :class_name => "User"
  has_one :published, :class_name => "PublishedJam", :dependent => :destroy
  has_many :likes, :class_name => "Like", :dependent => :destroy, :finder_sql => %q(
    select * from likes 
    where for_type='jam' and 
    for_type_id=#{id}
  )
  has_many :liked_by, :class_name => "User", :finder_sql => %q(
      SELECT "users".* FROM "users"  
      INNER JOIN "likes" ON "users".id = "likes".user_id    
      WHERE (("likes".for_type_id = #{id}))
  )
  has_many :comments, :class_name => "Comment", :dependent => :destroy, :finder_sql => %q(
    select * from comments 
    where for_type='jam' and 
    for_type_id=#{id}
  )
  
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
    Like.add(user, 'jam', self)
  end
  
  def unlike(user)
    JamLike.remove(self, user)
  end
  
  def jam_type
    return :song_jam if song_jam
    published ? :published : :unpublished
  end
  
  def self.published_jams
    self.find_all.select(&:published)
  end
  

end


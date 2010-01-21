class Jam < ActiveRecord::Base
  has_many :jam_artists, :dependent => :destroy
  has_many :artists, :through => :jam_artists
  has_one :song_jam, :foreign_key => "jam_id", :dependent => :destroy
  has_one :song, :through => :song_jam
  has_one :creator, :primary_key => 'registered_user_id', :foreign_key => 'id', :class_name => "User"
  has_one :published, :class_name => "PublishedJam", :dependent => :destroy
  has_many :sheets_of_music, :class_name => "SheetMusic"

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
  
  after_destroy :delete_file_handle

  include JamUtils
  
  def after_create
    self.tag_artist(self.creator)
    feed = Feed.add({:jam_id => self.id, :user_ids => [self.creator.id]}, "jam_created")
    feed.add_users([self.creator])
  end

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
  
  def song_jam_flattened?
    song_jam.is_flattened
  end
  
  def visited
    self.views ||= 0
    self.views += 1
    self.save
  end

  def publish
    jam = self.song ? self.make_copy_and_publish("#{self.name} (published)") : self # If jam part of a song, then a copy of the jam will be published 
    PublishedJam.add(jam)
    users = jam.artists
    feed = Feed.add({:user_ids => users.map(&:id), :jam_id => self.id}, "jam_published")
    feed.add_users(users)
  end

  def like(user)
    Like.add(user, 'jam', self.id)
  end
  
  def unlike(user)
    Like.remove(user, 'jam', self.id)
  end
  
  def jam_type
    return :song_jam if song_jam
    published ? :published : :unpublished
  end
  
  def self.published_jams
    self.find_all.select(&:published)
  end
  
  def add_to_song(song)
    song.add_jam(self)
  end
  
  def genres
    Genre.fetch("jam", self.id)
  end
  
  def jam_picture
    return (ENV["WEBSERVER_ROOT"] + "/public/images/icons/8thnote.png") if not jam_picture_file_handle
    get_storage_file_path(jam_picture_file_handle)
  end
  
  def change_jam_picture(file)
    storage_dir = ENV['STORAGE_DIR']
    filename = new_file_handle_name(false)
    delete_storage_file(self.jam_picture_file_handle) if jam_picture_file_handle
    File.copy(file.path, storage_dir + "/" + filename)
    self.jam_picture_file_handle = filename
    self.save
  end
  
  def add_sheet_music(sheet_type, description, file)
    SheetMusic.add(self, sheet_type, description, file)
  end
  
end


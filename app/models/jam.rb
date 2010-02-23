class Jam < ActiveRecord::Base
  has_many :jam_artists, :dependent => :destroy
  has_many :artists, :through => :jam_artists
  has_one :song_jam, :foreign_key => "jam_id", :dependent => :destroy
  has_one :song, :through => :song_jam
  has_one :creator, :primary_key => 'registered_user_id', :foreign_key => 'id', :class_name => "User"
  has_one :published, :class_name => "PublishedJam", :dependent => :destroy
  has_one :added_by_user, :class_name => "User", :foreign_key => 'id', :primary_key => "added_by_user_id"
  has_many :sheets_of_music, :class_name => "SheetMusic"

  has_many :liked_by, :class_name => "User", :finder_sql => %q(
      SELECT "users".* FROM "users"  
      INNER JOIN "likes" ON "users".id = "likes".user_id    
      WHERE (("likes".for_type_id = #{id} AND ("likes".for_type = 'jam')))
  )
  has_many :comments, :class_name => "Comment", :dependent => :destroy, :finder_sql => %q(
    select * from comments 
    where for_type='jam' and 
    for_type_id=#{id}
  )
  
  after_destroy after_destroy

  include JamUtils
  
  def after_destroy
    Notification.delete_by_data("jam_id", self.id)
    Feed.delete_by_data("jam_id", self.id)
  end
  
  def displayable?
    self.published or self.song.published? rescue nil
  end
  
  def after_create
    return true if not self.artists.empty?
    puts "is it here?"
    self.tag_artist(self.creator)
  end
  
  def self.latest_displayable(count=:all)
    self.all.select(&:displayable?).first(count)
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
    raise "You may not publish the jam as there is no mp3 uploaded." if not self.file_handle
    jam = self.song ? self.make_copy_and_publish("#{self.name} (published)") : self # If jam part of a song, then a copy of the jam will be published 
    PublishedJam.add(jam)
    users = jam.artists
    feed = Feed.add({:user_ids => users.map(&:id), :jam_id => self.id}, "jam_published", "global")
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
  
  def add_to_song(song, added_by_user=nil)
    song.add_jam(self, added_by_user)
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
  
  def add_tag(name)
    Tag.add(name, "jam", self.id)
  end
  
  def tags
    Tag.fetch('jam', self.id)
  end
  
  # Copy Jams Code
  
  def make_copy_of_file_handle(newname=nil)
    puts file_handle
    utils_make_copy_of_file_handle(file_handle, newname)
  end
  
  def make_copy(newname=nil, added_by_user=nil)
    attrs = self.attributes
    file_handle_name = new_file_handle_name
    newattrs = attrs.keys_to_sym.delete_keys(:id, :created_at, :views)
    newattrs[:created_at] = Time.now # WORK AROUND. As CREATED_AT was taking the old CREATED_AT value
    newattrs[:added_by_user_id] = added_by_user.nil? ? self.creator.id : added_by_user.id
    newattrs[:origin_jam_id] = self.id
    
    puts newattrs
    
    newjam = Jam.new(newattrs)
#    File.copy(file_handle_path(self), (FILES_DIR + "/" + file_handle_name)) if file_handle_exists? # Makes a copy of the physical file
    newjam.name = newname || ("#{self.name} (copy)")
#    newjam.file_handle = file_handle_name if file_handle_exists?
    newjam.save    
    
    # Tags all the Artists of the orginal song in the copy
    self.artists.each do |artist| 
      puts "before it is: #{artist.name} #{artist.id}"
      newjam.tag_artist(artist) 
    end
    self.tags.each do |tag| newjam.add_tag(tag.name) end # Copies over the tags from jam to the new am 
    newjam
  end
  
  def make_copy_and_publish(newname=nil)
    jam = make_copy(newname)
    jam.publish
    jam
  end
  
  def father
    Jam.find(self.origin_jam_id) if origin_jam_id
  end
  
  # Points to the ROOT of a Jam's Lineage
  def adam
    jam = self.father
    while jam.origin_jam_id; jam = jam.father; end
    jam
  end
  
  def children
    Jam.find_all_by_origin_jam_id(self.id)
  end
  
  def descendants
    jams = []
    jams = self.children
    jams + jams.map{ |child| child.descendants}.flatten
  end
  
  def lineage_song_count
    ([self] + self.descendants).select(&:song_jam).size
  end
  
  def self.published(count=9)
    self.find(:all, :order => "id DESC", :limit => count).select(&:published)
  end
  
  def added_by_other
    (not added_by_user_id.nil?) and (added_by_user != creator)
  end
  
end


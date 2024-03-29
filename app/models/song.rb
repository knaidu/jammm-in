class Song < ActiveRecord::Base
  has_many :song_jams, :dependent => :destroy
  has_many :jams, :through => :song_jams
  has_many :song_managers, :dependent => :destroy
  has_many :managers, :through => :song_managers
  belongs_to :creator, :class_name => "User", :foreign_key => "registered_user_id"
  has_one :song_lyric, :dependent => :destroy
  has_many :messages, :dependent => :destroy, :class_name => "SongManageMessage", :order => "created_at"
  has_many :comments, :class_name => "Comment", :dependent => :destroy, :finder_sql => %q(
    select * from comments 
    where for_type='song' and 
    for_type_id=#{id}
  )
  has_many :liked_by, :class_name => "User", :finder_sql => %q(
      SELECT "users".* FROM "users"  
      INNER JOIN "likes" ON "users".id = "likes".user_id    
      WHERE (("likes".for_type_id = #{id} AND ("likes".for_type = 'song')))
  )
  
  has_one :file_data, :primary_key => 'file_handle', :foreign_key => 'file_handle', :class_name => "FileData"
  has_one :flattened_file_data, :primary_key => 'flattened_file_handle', :foreign_key => 'file_handle', :class_name => "FileData"
  
  after_destroy after_destroy

  include SongUtils

  def after_destroy
    self.song_managers.each(&:destroy)
    self.messages.each(&:destroy)
    Notification.delete_by_data("song_id", self.id)
    Feed.delete_by_data("song_id", self.id)
  end
  
  def after_create
    add_to_manager_list
  end
  
  def artists
    jams.map(&:artists).flatten.uniq
  end
  
  def active_artists
    active_jams.map(&:artists).flatten.uniq
  end
  
  def add_to_manager_list
    add_manager(creator)
  end
  
  def file
    File.open(file_handle_path(self)) rescue nil
  end
  
  def flattened_file
    File.open(flattened_file_handle_path(self)) rescue nil    
  end
  
  def delete_file_handle
    File.delete(self.file.path) if self.file_handle
    self.file_handle = nil
    self.save
  rescue
    nil
  end
  
  def delete_flattened_file_handle 
    File.delete(self.flatten_file.path) if self.flatten_file_handle
    self.flattened_file_handle = nil
    self.save
  rescue
    nil  
  end
  
  def file_handle_exists?
    file_handle and File.exists?(file_handle_path(self))
  end
  
  def flattened_file_handle_exists?
    true if flattened_file_handle
  end
  
  def flattened_file_data
    FileData.find_by_file_handle(flattened_file_handle) || FileData.create({:file_handle => flattened_file_handle})
  end
  
  def save_song_jams_data(jams_arr)
    jams_arr.each {|jam_data|
      arr = jam_data.split(',')
      jam = Jam.find(arr[0])
      song_jam = jam.song_jam
      song_jam.volume = arr[1]
      song_jam.save
    }
  end
  
  def flatten_jams(jams=[])
    process_id = ProcessInfo.available_process_id
    cmd = [
        "ruby",
        "#{APP_ROOT}/scripts/flatten_song.rb",
        "--jams=#{jams.map(&:id).join(',')}",
        "--song=#{self.id}",
        "--process_id=#{process_id}"
    ].join(' ')
    run(cmd)
    process_id
  end
  
  def publish
    raise "You must first preview the collaboration in order to publish it" if song_jams.select(&:is_flattened).empty?
    self.delete_file_handle if self.file_handle_exists?  
    song_jams(true).each do |song_jam|
      song_jam.is_flattened ? song_jam.activate : song_jam.deactivate
    end
    new_file_handle = new_file_handle_name
    utils_make_copy_of_file_handle(self.flattened_file_handle, new_file_handle)
    self.file_handle = new_file_handle
    self.flattened_file_handle = nil
    self.save
    fresh_song = self.class.find(self.id)
    FileData.create_waveform(fresh_song)
    FileData.gather(fresh_song)
    self.send_publish_feed_and_notification
    self.add_memory_to_users
    self
  end

  
  def published
    song_jams.any?(&:active?)
  end
  alias published? published
  
  def unpublished?
    not published
  end
  
  def unpublish
    song_jams.each(&:deactivate)
    delete_file_handle
  end
  
  def like(user)
    Like.add(user, 'song', self.id)
  end
  
  def unlike(user)
    Like.remove(user, 'song', self.id)
  end
  
  def add_lyrics(user, lyrics)
    SongLyric.add(user, self, lyrics)
  end
  
  def lyrics
    song_lyric.lyrics rescue nil
  end
  
  def self.published_songs
    self.find_all.select(&:published).sort_by{|s| -(s.id)}
  end
  
  def add_jam(jam, added_by_user=nil)
    raise "You cannot add this jam as it does not have a mp3 uploaded" if not jam.file_handle
    raise "This jam cannot be added as the policy does not allow it" unless jam.addable?(added_by_user)
    jam_adam = (jam.adam or jam)
    jam_name = jam.name
    jam = jam.make_copy(jam_name, added_by_user) if jam.published or jam.song_jam # Adds a copy of a jam to the song, if jam already published
    SongJam.create({:song_id => self.id, :jam_id => jam.id})
    
    # Sends notification to all the other song managers
    notification = Notification.add({:song_id => self.id, :jam_id => jam.id}, "jam_added_to_song")
    notification.add_users([jam.creator])
  end
  
  def remove_jam(jam)
    SongJam.find_by_song_id_and_jam_id(self.id, jam.id).destroy
  end
  
  def active_jams
    song_jams.select(&:active).map(&:jam)
  end
  
  def addable_jams(user)
    jams.select{|jam| jam.addable?(user)}
  end
  
  def add_to_song(song, added_by_user=nil)
    jams.each do |jam|
      song.add_jam(jam, added_by_user)
    end
  end
  
  def add_music(music_type, music_id, added_by_user=nil)
    music_obj = music_type.find_by_id(music_id)
    music_obj.add_to_song(self, added_by_user)
  end
  
  def genres
    Genre.fetch("song", self.id)
  end
  
  def song_picture
    return (ENV["WEBSERVER_ROOT"] + "/public/images/icons/default-song.png") if not song_picture_file_handle
    get_storage_file_path(song_picture_file_handle)
  end
  
  def change_song_picture(file)
    storage_dir = ENV['STORAGE_DIR']
    filename = new_file_handle_name(false)
    delete_storage_file(self.song_picture_file_handle) if song_picture_file_handle
    File.copy(file.path, storage_dir + "/" + filename)
    self.song_picture_file_handle = filename
    self.save
    sleep(5)
    img = Image.new(song_picture)
    img.resize_and_crop(120, 120)
  rescue
    sleep(5) 
    img = Image.new(song_picture)
    img.resize_and_crop(120, 120)
  end
  
  def song_picture_url
    return "/new-ui/collaborate.png" if song_picture_file_handle.nil?
    "/song/#{self.id}/song_picture?#{self.song_picture_file_handle.to_s}"
  end
  
  def instruments
    jams.map(&:instrument).compact
  end
  
  def genres
    Genre.fetch("song", self.id)
  end
  
  def genre_names
    genres.map(&:name).join(", ")
  end
  
  def tags
    Tag.fetch('song', self.id)
  end
  
  def add_manage_message(user, message)
    raise "The body of the message cannot be empty" if message.nil? or message.empty?
    SongManageMessage.add(self, user, message)
  end
  
  def send_invite_notification(user)
    notification = Notification.add({:song_id => self.id}, "song_invite")
    notification.add_users([user])
  end
  
  def send_publish_feed_and_notification
    feed = Feed.add({:user_ids => artists.map(&:id), :song_id => self.id}, "song_published", "global")
    feed.add_users(artists)
    
    notification = Notification.add({:song_id => self.id}, "song_publish")
    notification.add_users([artists] - [self.creator])
  end
  
  def unread_messages(user)
    song_manager = SongManager.find_by_manager_id_and_song_id(user.id, self.id)
    self.messages.select do |message| 
      last_read_at = song_manager.last_read_messages_at
      (last_read_at == nil) or (message.created_at > last_read_at)
    end
  end
  
  def add_memory_to_users
    creator.add_memory(MEMORY_DETAILS["collaborate"])
    users = active_artists - [creator]
    users.each{|u| u.add_memory(MEMORY_DETAILS["used_in_collaboration"])}
  end
  
  def self.published(count=:all)
    options = {:order => "id DESC"}
    self.find(:all, options).select(&:published).slice(0, count)
  end
  
end

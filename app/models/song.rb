class Song < ActiveRecord::Base
  has_many :song_jams, :dependent => :destroy
  has_many :jams, :through => :song_jams
  has_many :song_managers, :dependent => :destroy
  has_many :managers, :through => :song_managers
  belongs_to :creator, :class_name => "User", :foreign_key => "registered_user_id"
  has_one :song_lyric, :dependent => :destroy
  has_many :comments, :class_name => "Comment", :dependent => :destroy, :finder_sql => %q(
    select * from comments 
    where for_type='song' and 
    for_type_id=#{id}
  )
  has_many :liked_by, :class_name => "User", :finder_sql => %q(
      SELECT "users".* FROM "users"  
      INNER JOIN "likes" ON "users".id = "likes".user_id    
      WHERE (("likes".for_type_id = #{id}))
  )
  
  after_destroy :remove_tenticles

  include SongUtils
  
  def after_create
    add_to_manager_list
    feed = Feed.add({:song_id => self.id, :user_ids => [self.creator.id]}, "song_created")
    feed.add_users([self.creator])
  end
  
  def artists
    jams.map(&:artists).flatten.uniq
  end
  
  def add_to_manager_list
    add_manager(creator)
  end
  
  def remove_tenticles
    delete_file_handle
  end
  
  def file
    File.open(file_handle_path(self)) rescue nil
  end
  
  def delete_file_handle
    File.delete(self.file.path) if self.file_handle
    self.file_handle = nil
    self.save
  rescue
    nil
  end
  
  def file_handle_exists?
    file_handle and File.exists?(file_handle_path(self))
  end
  
  def publish(jams=[])
    process_id = ProcessInfo.available_process_id
    cmd = [
        "ruby",
        "#{APP_ROOT}/scripts/publish_song.rb",
        "--jams=#{jams.map(&:id).join(',')}",
        "--song=#{self.id}",
        "--process_id=#{process_id}"
    ].join(' ')
    run(cmd)
    process_id
  end
  
  def published
    song_jams.any?(&:active?)
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
    self.find_all.select(&:published)
  end
  
end

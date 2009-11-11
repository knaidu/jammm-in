class Song < ActiveRecord::Base
  has_many :song_jams, :dependent => :destroy
  has_many :jams, :through => :song_jams
  has_many :song_managers, :dependent => :destroy
  has_many :managers, :through => :song_managers
  belongs_to :creator, :class_name => "User", :foreign_key => "registered_user_id"
  has_many :song_likes
  has_many :liked_by, :through => :song_likes, :dependent => :destroy
  
  after_create :add_to_manager_list
  after_destroy :remove_tenticles

  include SongUtils
  
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
    puts 'huh'
    self.file_handle = nil
    self.save
  end
  
  def file_handle_exists?
    file_handle and File.exists?(file_handle_path(self))
  end
  
  def publish(jams=[])
    ids = jams.map(&:id)
    song_jams.each do |song_jam|
      ids.include?(song_jam.jam_id) ? song_jam.activate : song_jam.deactivate
    end
    delete_file_handle if file_handle_exists?
    self.file_handle = jams[0].make_copy_of_file_handle(new_file_handle_name) if jams[0].file_handle_exists?
    puts "the last file handle #{self.file_handle.to_s}"
    self.save
  end
  
  def published
    song_jams.any?(&:active?)
  end
  
  def unpublish
    song_jams.each(&:deactivate)
    delete_file_handle
  end
  
  def like(user)
    SongLike.add(self, user)
  end
  
  def unlike(user)
    SongLike.remove(self, user)
  end
  
end

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
    File.delete(file.path) if file_handle
  end
  
  def file_handle_exists?
    file_handle and File.exists?(file_handle_path(self))
  end
  
end

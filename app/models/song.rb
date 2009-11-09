class Song < ActiveRecord::Base
  has_many :song_jams, :dependent => :destroy
  has_many :jams, :through => :song_jams
  has_many :song_managers, :dependent => :destroy
  has_many :managers, :through => :song_managers
  belongs_to :creator, :class_name => "User", :foreign_key => "registered_user_id"
  
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
    File.delete(file.path)
  end
  
  def file
    File.open(file_handle_path(self)) rescue nil
  end
  
end

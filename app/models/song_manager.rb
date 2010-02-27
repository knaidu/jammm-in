class SongManager < ActiveRecord::Base
  validates_uniqueness_of :manager_id, :scope => [:song_id]
  belongs_to :song
  belongs_to :manager, :foreign_key => "manager_id", :primary_key => "id", :class_name => "User"
  
  before_destroy :remove_manager_jams_from_song
  
  def self.add(song, manager)
    self.create({:song_id => song.id, :manager_id => manager.id})
  end
  
  def remove_manager_jams_from_song
    song = self.song
    song.jams_of_user(self.manager).each do |jam|
      SongJam.find_by_song_id_and_jam_id(song.id, jam.id).destroy
    end
    true
  rescue
    true
  end
  
  def set_last_read_messages_to_now
    self.last_read_messages_at = Time.now
    self.save
  end
  
end
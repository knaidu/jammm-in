class SongManager < ActiveRecord::Base
  validates_uniqueness_of :manager_id, :scope => [:song_id]
  belongs_to :song
  belongs_to :manager, :foreign_key => "manager_id", :primary_key => "id", :class_name => "User"
  
  before_destroy :remove_manager_jams_from_song
  
  def self.add(song, manager)
    self.create({:song_id => song.id, :manager_id => manager.id})
  end
  
  def remove_manager_jams_from_song
    return false if manager == song.creator rescue true # Destroy is not allowed if the creator of the song is the being deleted
    song = self.song
    song.jams_of_user(self.manager).each do |jam|
      SongJam.find_by_song_id_and_jam_id(song.id, jam.id).destroy
    end
    true
  rescue
    true
  end
  
end
class SongJam < ActiveRecord::Base
  belongs_to :song
  belongs_to :jam
  validates_uniqueness_of :jam_id, :scope => [:song_id]
  
  after_create :add_song_manager
  
  def add_song_manager
    song = self.song
    jam.artists.each do |manager| 
      song.add_manager manager
    end
  end
  
  def activate
    self.active = true
    self.save
  end
  
  def deactivate
    self.active = false
    self.save
  end
  
end

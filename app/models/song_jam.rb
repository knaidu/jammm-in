class SongJam < ActiveRecord::Base
  belongs_to :song
  belongs_to :jam
  validates_uniqueness_of :jam_id, :scope => [:song_id]
  
  after_create :after_create
  
  def after_create
    song = self.song
    jam.artists.each do |manager| 
      song.add_manager manager
    end
    
    # Adds the Tags of the Jam to the Song
    jam.tags.each do |tag|
      Tag.add(tag.name, 'song', song.id)
    end
  end
  
  def activate
    self.active = true
    self.is_flattened = false
    self.save
  end
  
  def deactivate
    self.active = false
    self.save
  end
  
  def flattened(state=true)
    self.is_flattened = state
    self.save
  end
  
end

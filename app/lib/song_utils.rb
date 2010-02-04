module SongUtils

  def register_song(username, name) 
    Song.create({
      :name => name,
      :registered_user_id => User.with_username(username).id
    })
  end
  
  def update_information(name, description)
    self.name = name
    self.description = description
    self.save
  end
  
  def add_jam(jam)
    raise "You cannot add this jam as it does not have a mp3 uploaded" if not jam.file_handle
    jam = jam.make_copy(jam.name + " (copy for song: #{self.name})") if jam.published # Adds a copy of a jam to the song, if jam already published
    SongJam.create({:song_id => self.id, :jam_id => jam.id})
  end
  
  def remove_jam(jam)
    SongJam.find_by_song_id_and_jam_id(self.id, jam.id).destroy
  end

  def visited
    self.views ||= 0
    self.views += 1
    self.save
  end
  
  def jams_of_user(user)
    self.jams.select do |jam| jam.artists.include?(user) end 
  end
  
  def add_manager(manager)
    SongManager.add(self, manager)
  end
  
  def remove_artist(artist)
    SongManager.find_by_song_id_and_manager_id(self.id, artist.id).destroy
  end

end 

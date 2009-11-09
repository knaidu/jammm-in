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
  
  def publish(jams=[])
    ids = jams.map(&:id)
    song_jams.each do |song_jam|
      ids.include?(song_jam.jam_id) ? song_jam.activate : song_jam.deactivate
    end
    delete_file_handle if file_handle_exists?
    self.file_handle = jams[0].make_copy_of_file_handle(new_file_handle_name)
    puts "the last file handle #{self.file_handle.to_s}"
    self.save
  end

end 

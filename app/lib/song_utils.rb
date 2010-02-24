module SongUtils

  def register_song(username, name) 
    regex = DATA["name_regex"]
    raise "The name can accept only alphabets,numbers, '-' and '_'" if not eval(regex).match(name)
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

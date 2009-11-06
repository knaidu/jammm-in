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
  
  def add_jam(jam_id)
    SongJam.create({:song_id => self.id, :jam_id => jam_id})
  end

  def visited
    self.views ||= 0
    self.views += 1
    self.save
  end

end 

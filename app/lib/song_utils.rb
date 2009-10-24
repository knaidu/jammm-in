module SongUtils

  def register_song(username, name, description) 
    Song.create({
      :name => name,
      :description => description, 
      :registered_user_id => User.with_username(username).id
    })
  end
  
  def add_jam(jam_id)
    SongJam.create({:song_id => self.id, :jam_id => jam_id})
  end

end 

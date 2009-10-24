module JamUtils

  def register_jam(username, name, description) 
    Jam.create({
      :name => name,
      :registered_user_id => User.with_username(username).id
    })
  end
  
  def add_artist(artist_id)
    JamArtist.create({:jam_id => self.id, :artist_id => artist_id})
  end

end 

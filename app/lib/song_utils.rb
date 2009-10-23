module SongUtils

  def register_song(username, name, description) 
    Song.create({
      :name => name,
      :description => description, 
      :registered_user_id => User.with_username(username).id
    })
  end

end 

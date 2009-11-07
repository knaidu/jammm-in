module JamUtils

  def register_jam(username, name) 
    Jam.create({
      :name => name,
      :registered_user_id => User.with_username(username).id
    })
  end

  def update_information(name, description)
    self.name = name
    self.description = description
    self.save
  end
  
  def tag_artist(artist_id)
    return nil if not self.class.to_s == "Jam"
    JamArtist.create({:jam_id => self.id, :artist_id => artist_id})
  end

  def untag_artist(user)
    JamArtist.find_by_jam_id_and_artist_id(self.id, user.id).destroy
  end

  def visited
    self.views ||= 0
    self.views += 1
    self.save
  end

  def update_file(file)
    files_dir = ENV['FILES_DIR']
    filename = Time.now.to_f.to_s.gsub('.', '-')
    delete_file_handle
    File.copy(file.path, files_dir + "/" + filename)
    self.file_handle = filename
    self.save
  end

  def delete_file_handle
    file_path = ENV['FILES_DIR'] + "/" + self.file_handle if file_handle
    File.delete(file_path) if file_handle and File.exists?(file_path)
    self.file_handle = nil
    self.save
  end

end 

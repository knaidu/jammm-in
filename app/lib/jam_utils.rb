module JamUtils

  def register_jam(username, name) 
    user = User.with_username(username)
    regex = DATA["name_regex"]
    raise "The name can accept only alphabets,numbers, '-' and '_'" if not eval(regex).match(name)
    Jam.create({
      :name => name,
      :registered_user_id => user.id,
      :created_at => Time.now,
      :added_by_user_id => user.id
    })
  end
  
  def tag_artist(artist)
    return nil if not self.class.to_s == "Jam"
    ja = JamArtist.create({:jam_id => self.id, :artist_id => artist.id})
    return ja if artist == self.creator

    # Notification
    notification = Notification.add({:user_id => artist.id, :jam_id => self.id}, "jam_tag")
    notification.add_users([artist])
  end

  def untag_artist(user)
    JamArtist.find_by_jam_id_and_artist_id(self.id, user.id).destroy
  end
  
  def unpublish
    published.destroy
  end

  def update_file(details)
    file = details[:tempfile]
    ext = "." + details[:filename].split(".").pop
    ext = ".aac" if ext == ".m4a" # As soundconverter does not understand m4a
    files_dir = ENV['FILES_DIR']
    puts file.path
    filename = new_file_handle_name(ext)
    File.copy(file.path, files_dir + "/" + filename)
    self.file_handle = filename
    self.save
#    run("ruby scripts/normalize_jam.rb #{self.id}")
    self.normalize
    fresh_jam = self.class.find(self.id) # Since the above lines might have updated the object
    fresh_jam.save_file_data
    FileData.create_waveform(fresh_jam)
  end

  def delete_file_handle
    file_path = ENV['FILES_DIR'] + "/" + self.file_handle if file_handle
    File.delete(file_path) if file_handle and File.exists?(file_path)
    self.save
  end

  def reconstruct_file
    path = fetch_local_file_path(self)
    self.normalize
    jam = Jam.find(self.id)
    FileData.gather(jam)
    FileData.create_waveform(jam)
  end

end 

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
  
  def publish
    jam = self.song ? self.make_copy_and_publish("#{self.name} (published)") : self # If jam part of a song, then a copy of the jam will be published 
    PublishedJam.add(jam)
  end
  
  def unpublish
    published.destroy
  end

  def update_file(file)
    files_dir = ENV['FILES_DIR']
    filename = new_file_handle_name
    delete_file_handle
    File.copy(file.path, files_dir + "/" + filename)
    self.file_handle = filename
    self.save
  end

  def delete_file_handle
    file_path = ENV['FILES_DIR'] + "/" + self.file_handle if file_handle
    File.delete(file_path) if file_handle and File.exists?(file_path)
    self.save
  end
  
  def make_copy(newname=nil)
    attrs = self.attributes
    new_file_handle_name = Utils.new_file_handle_name
    newattrs = attrs.keys_to_sym.delete_keys(:id, :created_at, :views, :file_handle)
    newattrs[:created_at] = Time.now # WORK AROUND. As CREATED_AT was taking the old CREATED_AT value
    
    newjam = Jam.new(newattrs)
    File.copy(file_handle_path(self), (FILES_DIR + "/" + new_file_handle_name)) if file_handle_exists? # Makes a copy of the physical file
    newjam.name = newname || ("#{self.name} (copy)")
    newjam.file_handle = new_file_handle_name if file_handle_exists?
    newjam.save    
    
    # Tags all the Artists of the orginal song in the copy
    self.artists.each do |artist| newjam.tag_artist(artist.id) end # tag
    newjam
  end
  
  def make_copy_and_publish(newname=nil)
    jam = make_copy(newname)
    jam.publish
    jam
  end

end 

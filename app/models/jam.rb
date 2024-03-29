class Jam < ActiveRecord::Base
  has_many :jam_artists, :dependent => :destroy
  has_many :artists, :through => :jam_artists
  has_one :song_jam, :foreign_key => "jam_id", :dependent => :destroy
  has_one :song, :through => :song_jam
  has_one :creator, :primary_key => 'registered_user_id', :foreign_key => 'id', :class_name => "User"
  has_one :published, :class_name => "PublishedJam", :dependent => :destroy
  has_one :added_by_user, :class_name => "User", :foreign_key => 'id', :primary_key => "added_by_user_id"
  has_many :sheets_of_music, :class_name => "SheetMusic"

  has_many :liked_by, :class_name => "User", :finder_sql => %q(
      SELECT "users".* FROM "users"  
      INNER JOIN "likes" ON "users".id = "likes".user_id    
      WHERE (("likes".for_type_id = #{id} AND ("likes".for_type = 'jam')))
  )
  has_many :comments, :class_name => "Comment", :dependent => :destroy, :finder_sql => %q(
    select * from comments 
    where for_type='jam' and 
    for_type_id=#{id}
  )
  
  has_one :file_data, :primary_key => 'file_handle', :foreign_key => 'file_handle', :class_name => "FileData"
  
  after_destroy after_destroy

  include JamUtils
  
  DEFAULT_JAM_IMAGE = "/images/jam.png?id=1"
  
  def after_destroy
    self.children.each{|jam| jam.set_father(self.father)} # Set all its children's father to its father
    Notification.delete_by_data("jam_id", self.id)
    Feed.delete_by_data("jam_id", self.id)
  end
  
  def self.construct_jam(user, name, instrument=nil, genre=nil, description=nil, file_details=nil)
    puts "FILE: " + file_details.inspect
    regex = DATA["name_regex"]
    raise "The name can accept only alphabets,numbers, '-' and '_'" if not eval(regex).match(name)
    jam = Jam.create({
      :name => name,
      :registered_user_id => user.id,
      :created_at => Time.now,
      :added_by_user_id => user.id,
      :description => description
    })
    jam.update_file(file_details)
    jam.update_instrument(instrument) if instrument
    ContainsGenre.add(genre, "jam", jam.id) if genre
    jam
  end
  
  def normalize
    run("ruby scripts/normalize_jam.rb #{self.id}")
  end
  
  def displayable?
    self.adam? and (self.published or (self.song_jam.active and self.song.published?)) rescue nil
  end
  
  def unpublished?
    (displayable? or self.song_jam) ? false : true
  end
  
  def after_create
    return true if not self.artists.empty?
    self.tag_artist(self.creator)
  end
  
  def self.latest_displayable(count=:all)
    self.find(:all, :order => "id DESC").select(&:displayable?).first(count)
  end

  def file
    File.open(ENV['FILES_DIR'] + "/" + file_handle) rescue nil
  end
  
  def file_handle_exists?
    file_handle and File.exists?(file_handle_path(self))
  end
  
  def delete_file_handle
    File.delete(file_handle_path(self)) if file_handle_exists?
  end
  
  def song_jam_active?
    song_jam.active rescue nil
  end
  
  def song_jam_flattened?
    song_jam.is_flattened
  end
  
  def visited
    self.views ||= 0
    self.views += 1
    self.save
  end

  def publish
    raise "You may not publish the jam as there is no mp3 uploaded." if not self.file_handle
#    jam = self.song ? self.make_copy_and_publish("#{self.name} (published)") : self # If jam part of a song, then a copy of the jam will be published 
    jam = self
    PublishedJam.add(jam)
    users = jam.artists
    feed = Feed.add({:user_ids => users.map(&:id), :jam_id => self.id}, "jam_published", "global")
    feed.add_users([jam.creator])
  end

  def like(user)
    Like.add(user, 'jam', self.id)
  end
  
  def unlike(user)
    Like.remove(user, 'jam', self.id)
  end
  
  def jam_type
    return :song_jam if song_jam
    published ? :published : :unpublished
  end
  
  def image_url_big
    self.instrument.icon_image_url_big rescue DEFAULT_JAM_IMAGE
  end
  
  def image_url_small
    self.instrument.icon_image_url_small rescue DEFAULT_JAM_IMAGE
  end
  
  def self.published_jams
    self.find_all.select(&:published)
  end
  
  def addable?(user)
    return true if policy == 'public'
    return true if policy == "school" and not (self.creator.schools & user.schools).empty?
    false
  end
  
  def add_to_song(song, added_by_user=nil)
    song.add_jam(self, added_by_user)
  end
  
  def genres
    Genre.fetch("jam", self.id)
  end
  
  def genre_names
    genres.map(&:name).join(", ")
  end
  
  def jam_picture
    return (ENV["WEBSERVER_ROOT"] + "/public/images/icons/8thnote.png") if not jam_picture_file_handle
    get_storage_file_path(jam_picture_file_handle)
  end
  
  def change_jam_picture(file)
    storage_dir = ENV['STORAGE_DIR']
    filename = new_file_handle_name(false)
    delete_storage_file(self.jam_picture_file_handle) if jam_picture_file_handle
    File.copy(file.path, storage_dir + "/" + filename)
    self.jam_picture_file_handle = filename
    self.save
  end
  
  def add_sheet_music(sheet_type, description, file)
    SheetMusic.add(self, sheet_type, description, file)
  end
  
  def add_tag(name)
    Tag.add(name, "jam", self.id)
  end
  
  def tags
    Tag.fetch('jam', self.id)
  end
  
  # Copy Jams Code
  
  def make_copy_of_file_handle(newname=nil)
    puts file_handle
    utils_make_copy_of_file_handle(file_handle, newname)
  end
  
  def make_copy(newname=nil, added_by_user=nil)
    attrs = self.attributes
    file_handle_name = new_file_handle_name
    newattrs = attrs.keys_to_sym.delete_keys(:id, :created_at, :views)
    newattrs[:created_at] = Time.now # WORK AROUND. As CREATED_AT was taking the old CREATED_AT value
    newattrs[:added_by_user_id] = added_by_user.nil? ? self.creator.id : added_by_user.id
    newattrs[:origin_jam_id] = self.id
    
    puts newattrs
    
    newjam = Jam.new(newattrs)
#    File.copy(file_handle_path(self), (FILES_DIR + "/" + file_handle_name)) if file_handle_exists? # Makes a copy of the physical file
    newjam.name = newname || ("#{self.name} (copy)")
#    newjam.file_handle = file_handle_name if file_handle_exists?
    newjam.save    
    
    # Tags all the Artists of the orginal song in the copy
    self.artists.each do |artist| 
      puts "before it is: #{artist.name} #{artist.id}"
      newjam.tag_artist(artist) 
    end
    self.tags.each do |tag| newjam.add_tag(tag.name) end # Copies over the tags from jam to the new am 
    FileData.create_waveform(newjam)
    newjam
  end
  
  def make_copy_and_publish(newname=nil)
    jam = make_copy(newname)
    jam.publish
    jam
  end
  
  def father
    Jam.find(self.origin_jam_id) if origin_jam_id
  end
  
  # Means itself is adam
  def adam?
    true unless adam
  end
  
  # Points to the ROOT of a Jam's Lineage
  def adam  
    return nil unless (jam = self.father)
    while jam.origin_jam_id; jam = jam.father; end
    jam
  end
  
  def children
    Jam.find_all_by_origin_jam_id(self.id)
  end
  
  def set_father(jam)
    self.origin_jam_id = jam.nil? ? nil : jam.id
    self.save
  end
  
  def descendants
    jams = []
    jams = self.children
    jams + jams.map{ |child| child.descendants}.flatten
  end
  
  def songs
    list = self.adam? ? ([self] + self.children) : ([self] + self.adam.children)
    list.map(&:song).compact.uniq 
  end
  
  def lineage_song_count
    ([self] + self.descendants).select(&:displayable?).map(&:song).uniq.compact.size
  end
  
  def self.published(count=9)
    self.find(:all, :order => "id DESC", :limit => count).select(&:published)
  end
  
  def added_by_other
    (not added_by_user_id.nil?) and (added_by_user != creator)
  end
  
  def depth
    i = 1
    jam = self
    while jam.father; jam = jam.father; i += 1; end
    i
  end
  
  def identical_ancester
    jam = self
    return jam unless self.father
    while (jam.father and (self.file_handle == jam.father.file_handle)); jam = jam.father; end
    jam
  end
  
  def instruments
    jam_artists.map(&:instruments).flatten
  end
  
  def instrument
    instruments.first
  end
  
  def update_instrument(instrument)
    ja_id = jam_artists[0].id
    cis = ContainsInstrument.find_all_by_for_type_and_for_type_id("jam_artist", ja_id)
    cis.each(&:destroy)
    ContainsInstrument.add(instrument, "jam_artist", ja_id)
  end
  
  def policy
    read_attribute(:policy) or "public"
  end
  
  def policy=(str)
    write_attribute(:policy, "public")
  end
  
  def set_policy(str)
    self.children.each{|jam|
      jam.policy = str
      jam.save
    }
    self.class.policies.find{|p| p[:name] == str}[:on_success_message]
  end
  
  def save_file_data
    FileData.gather self
  end
  
  def waveform_path
    file_data.waveform_path
  end

  class << self
    def policies
      [
        {
          :name => "public", :desc => "Public (Anyone can collaborate with)", 
          :on_success_message => "The policy has been set successfully. Anyone will be allowed to collaborate with this jam."
        },
        {
          :name => "school", :desc => "School (Can be collborated only within your schools)",
          :on_success_message => "The policy has been set successfully. All copies/descendants of this song will now have the same policy. Only artists belonging to your school(s) can use this jam in a collaboration"
        },
        {
          :name => "private", :desc => "Private (Cannot be collaborated with)",
          :on_success_message => "The policy has been set successfully. All copies/descendants of this song will now have the same policy. No one will be able to use this jam in a collaboration."
        }
      ]
    end
    
    def policy_names
      policies.map{|p| p[:name]}
    end
    
    def policy_info(str)
      policies.find{|p| p[:name] == str}
    end
    
  end
  
end

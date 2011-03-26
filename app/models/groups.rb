# GROUP
class Group < ActiveRecord::Base
  has_many :group_users, :dependent => :destroy
  has_many :users, :through => :group_users
  has_many :group_admins, :dependent => :destroy
  has_many :admins, :through => :group_admins, :foreign_key => "user_id"
  validates_uniqueness_of :handle 
  
  def add_user(user)
    GroupUser.add(self, user)
  end
  
  def add_admin(user)
    GroupAdmin.add(self, user)    
  end
  
  def remove_user(user)
    ga = GroupUser.find_by_group_id_and_user_id(self.id, user.id)
    ga.destroy
  end
  
  def jams
    return [] if users.empty?  
    ids = users.map(&:id).join(",")
    jams = (Jam.find_by_sql [
        "SELECT *",
        "FROM jams",
        "WHERE registered_user_id in (#{ids})",
        "ORDER BY id DESC limit 100"
      ].join(' '))
    jams
  end
  
  def songs
    return [] if users.empty?
    ids = users.map(&:id).join(",")
    songs = (Song.find_by_sql [
        "SELECT s.*",
        "FROM songs s, song_managers sm",
        "WHERE (s.id=sm.song_id and sm.manager_id in (#{ids}))",
        "ORDER BY created_at DESC limit 100"
      ].join(' '))
    songs
  end
  
  def feeds(limit=100)
    return [] if users.empty?
    ids = users.map(&:id).join(",")
    my_feeds = (Feed.find_by_sql [
        "SELECT f.*",
        "FROM feeds f, user_feeds uf",
        "WHERE (f.id=uf.feed_id and uf.user_id in (#{ids})) and f.feed_type != 'say' and f.feed_type != 'user_created'",
        "ORDER BY created_at DESC limit #{limit}"
      ].join(' '))
  end
  
  def change_profile_picture(file)
    storage_dir = ENV['STORAGE_DIR']
    filename = new_file_handle_name(false)
    full_file_name = storage_dir + "/" + filename
    File.copy(file.path, full_file_name)
    self.profile_picture = full_file_name
    self.save
    temp_img = Image.new(self.profile_picture)
    temp_img.resize_and_crop(100, 100)
    true
  end
  
  def profile_picture_url
    return "/new-ui/collaborate.png" unless profile_picture
    r = profile_picture.split("/").pop
    "/groups/#{handle}/profile_picture?#{r}"
  end
  
  def set_promotion_code(force=false)
    raise "Promotion code already set. call set_promotion_code(true) to force a reset" if promotion_code and force == false
    code = ("a".."z").map.shuffle.join("")
    self.promotion_code = code
    self.save
  end
  
  def set_invites_remaining(no=50)
    self.invites_remaining = no
    self.save
  end
  
  def decrement_invites_remaining
    self.invites_remaining -= 1
    self.save
  end
  
  def signup_link
    "http://jammm.in#code=#{promotion_code}-#{self.id};group"
  end
  
  def self.group_from_code(code)
    g_id = code.split(";")[0].split("-")[1]
    self.find(g_id)
  end
  
end

# GROUP USER
class GroupUser < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  validates_uniqueness_of :user_id, :scope => [:group_id]
  
  def self.add(group, user)
    create({:group_id => group.id, :user_id => user.id})
  end
end

class GroupAdmin < ActiveRecord::Base
  belongs_to :group
  belongs_to :user
  belongs_to :admin, :foreign_key => "user_id", :primary_key => "id", :class_name => "User"
  validates_uniqueness_of :user_id, :scope => [:group_id]
  
  def self.add(group, user)
    create({:group_id => group.id, :user_id => user.id})
  end
  
end

class GroupCategories < ActiveRecord::Base
  set_table_name "group_categories"
  has_many :groups
  has_many :groups, :primary_key => 'id', :foreign_key => 'category_id', :class_name => "Group"
  validates_uniqueness_of :name
end
class Badge

  attr_accessor :name, :image_url

  def self.all
    BADGES_DATA["types"].keys.map{|id| Badge.find(id)}
  end
  
  def self.find(id)
    Badge.new(id)
  end  
  
  def initialize(id)
    data = BADGES_DATA
    @badge = data["types"][id].update("id" => id)
    raise "Badge not found" if not @badge
  end
  
  def name
    @badge["name"]
  end
  
  def id
    @badge["id"]
  end
  
  def image_url
    BADGES_DATA["base_images_url"] + "/" + @badge["image"]  
  end 
  
  def users
    UserBadge.find_all_by_badge_id(self.id).map(&:user)
  end
  
end



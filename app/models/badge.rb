class Badge

  attr_accessor :name, :image_url

  def self.list
    
  end
  
  def self.find(id)
    
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
  
end



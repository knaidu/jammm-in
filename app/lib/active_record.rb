class ActiveRecord::Base < Object

  def self.find_all(*args)
    self.find(:all, *args)
  end
  
  def self.named(name)
    self.find_by_name(name)
  end

  def self.with_username(username)
    user = self.find_by_username(username)
  end
  
  def self.latest(count=5)
    self.find(:all, :order => "id DESC", :limit => count)
  end
  
  def append(attrs)
    self.update_attributes(attrs)
    self.save
  end

end

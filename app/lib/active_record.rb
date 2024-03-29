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
  
  def self.with_handle(handle)
    self.find_by_handle handle
  end
  
  def append(attrs)
    self.update_attributes(attrs)
    self.save
  end
  
  def update_info(key, value)
    write_attribute(key.to_s, value)
    save
  end

end

class ActiveRecord::Base < Object

  def self.find_all(*args)
    self.find(:all, *args)
  end
  
  def self.named(name)
    self.find_by_name(name)
  end

  def self.with_username(username)
    user = self.find_by_username(username)
    raise "Username '#{username}' does not exists." if not user
    user
  end
  
  def append(attrs)
    self.update_attributes(attrs)
    self.save
  end

end

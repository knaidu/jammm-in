class ActiveRecord::Base < Object

  def self.find_all(*args)
    self.find(:all, *args)
  end
  
  def self.named(name)
    self.find_by_name(name)
  end

end

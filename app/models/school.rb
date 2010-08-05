class School < ActiveRecord::Base
  validates_presence_of :name, :handle
  validates_uniqueness_of :handle
  
  def self.add(data)
    self.create(data)
  end
  
  def self.with_handle(handle)
    self.find_by_handle(handle)
  end
  
end
class School < ActiveRecord::Base
  validates_presence_of :name, :handle
  validates_uniqueness_of :handle
  has_many :school_users
  has_many :users, :through => :school_users
  
  def add_user(user)
    SchoolUser.add(self, user)
  end
  
  def jams
    users.map(&:jams).flatten.uniq.sort_by{|jam| -(jam.id)}
  end
  
  def songs
    users.map(&:songs).flatten.uniq.sort_by{|song| -(song.id)}
  end
  
  class << self
    def add(data)
      self.create(data)
    end
  
    def with_handle(handle)
      self.find_by_handle(handle)
    end
  end
  
end
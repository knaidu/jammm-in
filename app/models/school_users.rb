class SchoolUser < ActiveRecord::Base
  validates_presence_of :user_id, :school_id
  validates_uniqueness_of :user_id, :scope => :school_id
  belongs_to :user
  belongs_to :school
  
  def self.add(school, user)
    self.create({:school_id => school.id, :user_id => user.id})
  end
  
end
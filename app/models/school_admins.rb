class SchoolAdmin < ActiveRecord::Base
  validates_presence_of :school_id
  validates_presence_of :user_id
  
  belongs_to :user
  belongs_to :school
  
end
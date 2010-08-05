class UsersSchools < ActiveRecord::Base
  validates_presence_of :user_id, :school_id
    
  belongs_to :user
  belongs_to :school

  
end
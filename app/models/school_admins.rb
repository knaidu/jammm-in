class SchoolAdmin < ActiveRecord::Base
  validates_presence_of :school_id
  validates_presence_of :user_id
  
  belongs_to :user
  belongs_to :school
  belongs_to :admin, :class_name => "User", :primary_key => "id", :foreign_key => "user_id"

end

class Say < ActiveRecord::Base
  validates_presence_of :school_id, :school_name
  
end
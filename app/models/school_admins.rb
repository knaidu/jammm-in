class SchoolAdmin < ActiveRecord::Base
  validates_presence_of :school_id
  validates_presence_of :user_id
  validates_uniqueness_of :user_id, :scope => [:school_id]
  
  belongs_to :user
  belongs_to :school
  belongs_to :admin, :class_name => "User", :primary_key => "id", :foreign_key => "user_id"
  
  def self.add(school, user)
    school.add_user(user) unless school.users.include?(user)
    self.create(:school_id => school.id, :user_id => user.id)
  end

end

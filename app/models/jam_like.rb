class JamLike < ActiveRecord::Base
  belongs_to :jam
  belongs_to :user
  validates_uniqueness_of :user_id, :scope => [:jam_id]
  belongs_to :liked_by, :class_name => "User", :primary_key => "id", :foreign_key => "user_id" 
  
  def self.add(jam, user)
    self.create({:jam_id => jam.id, :user_id => user.id})
  end
  
end

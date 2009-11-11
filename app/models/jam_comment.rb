class JamComment < ActiveRecord::Base
  belongs_to :user 
  belongs_to :jam 
  
  def self.add(jam, user, comment)
    self.create({
      :jam_id => jam.id,
      :user_id => user.id,
      :comment => comment
    })
  end
  
end
class Say < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :message
  
  def self.add(user, message)
    self.create({
      :user_id => user.id,
      :message => message
    })
  end
end
class UserMessageMap < ActiveRecord::Base
  
  has_many :messages, :dependent => :destroy
  validates_uniqueness_of :user_1_id, :scope => [:user_2_id]
  
  def self.add(user_1, user_2)
    self.create({
      :user_1_id => user_2.id,
      :user_2_id => user_2.id
    })
  end
  
end
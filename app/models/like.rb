class Like < ActiveRecord::Base
  belongs_to :user
  
  def self.add(user, for_type, for_type_id)
    self.create({
      :user_id => user.id,
      :for_type => for_type,
      :for_type_id => for_type_id
    })
  end  
  
  def self.remove(user, for_type, for_type_id)
    self.find_by_user_id_and_for_type_and_for_type_id(user.id, for_type, for_type_id).destroy
  end
  
end
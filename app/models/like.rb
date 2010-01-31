class Like < ActiveRecord::Base
  belongs_to :user
  
  def add_notification
    notification = Notification.add({
      :user_id => user.id,
      :"#{for_type}_id" => for_type_id
    }, "like")
    notification.add_users(obj_from_data(for_type, for_type_id).artists)
  end
  
  def self.add(user, for_type, for_type_id)
    like = Like.create({:user_id => user.id, :for_type => for_type, :for_type_id => for_type_id})
    like.add_notification
  end  
  
  def self.remove(user, for_type, for_type_id)
    self.find_by_user_id_and_for_type_and_for_type_id(user.id, for_type, for_type_id).destroy
  end
  
end
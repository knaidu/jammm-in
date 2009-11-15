class Comment < ActiveRecord::Base
  
  belongs_to :user
  
  def self.add(user, comment, for_type, for_type_id)
    self.create({
      :user_id => user.id,
      :comment => comment,
      :for_type => for_type,
      :for_type_id => for_type_id
    })
  end
  
  def self.fetch(for_type, for_type_id)
    Comment.find_all_by_for_type_and_for_type_id(for_type, for_type_id)
  end
  
  def remove_comment(requesting_user)
    self.destroy
  end
  
end
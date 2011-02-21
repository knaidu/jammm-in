class Comment < ActiveRecord::Base
  
  belongs_to :user
  
  after_destroy after_destroy
  
  def after_destroy
    Notification.delete_by_data("comment_id", self.id)
    Feed.delete_by_data("comment_id", self.id)
  end
  
  def self.add(user, comment, for_type, for_type_id)
    comment = self.create({
      :user_id => user.id,
      :comment => comment,
      :for_type => for_type,
      :for_type_id => for_type_id
    })
    comment.add_notification
    comment.add_feed
    user.add_memory(MEMORY_DETAILS['comment'])
    comment
  end
  
  def self.fetch(for_type, for_type_id)
    Comment.find_all_by_for_type_and_for_type_id(for_type, for_type_id)
  end
  
  def remove_comment(requesting_user)
    self.destroy
  end
  
  def add_notification
    notification = Notification.add({
      :user_id => user.id,
      :"#{for_type}_id" => for_type_id,
      :comment_id => self.id
    }, "comment")
    notification.add_users(obj_from_data(for_type, for_type_id).artists - [user])
  end
  
  def add_feed
    feed = Feed.add({
      :user_ids => [user.id],
      :"#{for_type}_id" => for_type_id,
      :comment_id => self.id
    }, "#{for_type}_comment")
    feed.add_users([user])
  end
  
end

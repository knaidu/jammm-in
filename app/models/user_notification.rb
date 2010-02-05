class UserNotification < ActiveRecord::Base
  validates_uniqueness_of :user_id, :scope => :notification_id
  belongs_to :user
  belongs_to :notification
  
end

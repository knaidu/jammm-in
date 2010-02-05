class Notification < ActiveRecord::Base
  
  before_save {|record| record.created_at = Time.now}
  has_many :user_notifications, :dependent => :destroy
  has_many :users, :through => :user_notifications
  
  def self.add(data={}, notification_type="update")
    self.create({:data_str => data.to_json, :notification_type => notification_type})
  end
  
  def add_users(users)
    users.each {|user|
      UserNotification.create({:user_id => user.id, :notification_id => self.id})
    }
  end
  
  def set_global
    UserNotification.create({:user_id => 0, :notification_id => self.id})
  end
  
  def data
    self.data_str.eval_json rescue nil
  end

end

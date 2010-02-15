class Notification < ActiveRecord::Base
  
  before_save {|record| record.created_at = Time.now}
  has_many :user_notifications, :dependent => :destroy
  has_many :users, :through => :user_notifications
  
  # Mapping of Notifications-Types to ICONs
  ICON = {
    :follows => :following,
    :comment => :comments,
    :jam_tag => :jam,
    :new_message => :comments
  }
  
  def self.add(data={}, notification_type="update")
    self.create({:data_str => data.to_json, :notification_type => notification_type})
  end
  
  def add_users(users)
    users.each {|user|
      UserNotification.create({:user_id => user.id, :notification_id => self.id})
    }
  end
  
  def icon
    self.class::ICON[self.notification_type.to_sym] || self.notification_type.to_sym
  end
  
  def data
    NotificationData.new(self.data_str.eval_json) rescue nil
  end
  
  class NotificationData
    attr_accessor :text, :options
    
    def initialize(data)
      @data = data
    end
    
    def user
      User.find(@data["user_id"]) rescue nil
    end
    
    def users
      @data["users_ids"].map{|user_id| User.find(user_id)} rescue nil
    end
    
    def song
      Song.find(@data["song_id"]) rescue nil
    end
    
    def jam
      Jam.find(@data["jam_id"]) rescue nil
    end
    
    def message
      UserMessageStream.find(@data["message_id"]) rescue nil      
    end
    
  end

end

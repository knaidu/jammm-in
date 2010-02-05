class CreateNotificationsAndUserNotificationsTables < ActiveRecord::Migration
  
  def self.up
    # Song Song Lyrics
    create_table :notifications do |i|
      i.column :data_str, :string
      i.column :notification_type, :string
      i.column :created_at, :timestamp, :default => Time.now
    end    
    
    create_table :user_notifications do |i|
      i.column :notification_id, :integer
      i.column :user_id, :integer
    end
    
  end
  
  def self.down
    drop_table :notifications
    drop_table :user_notifications
  end
end

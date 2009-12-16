class CreateMessageStreamTables < ActiveRecord::Migration
  
  def self.up
    # Song Like Table
    
    create_table :user_message_stream_maps do |i|
      i.column :user_id, :integer
      i.column :message_stream_id, :integer
    end
    
    create_table :message_streams do |i|
      i.column :id, :integer
    end    
    
    create_table :user_message_streams do |i|
      i.column :message_stream_id, :integer
      i.column :user_id, :integer
      i.column :body, :string
      i.column :unread, :boolean, :default => true
      i.column :created_at, :timestamp, :default => Time.now
    end
  end
  
  def self.down
    drop_table :user_message_stream_maps
    drop_table :user_message_streams
    drop_table :message_streams
  end
end

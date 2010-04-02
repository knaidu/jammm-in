class CreateChatTables < ActiveRecord::Migration
  def self.up
    create_table :chat_users do |i|
      i.column :user_id, :integer
      i.column :message, :text
      i.column :signed_in_at, :timestamp
      i.column :last_ping_at, :timestamp
    end
        
    create_table :chat_messages do |i|
      i.column :user_id, :integer
      i.column :message, :text
      i.column :created_at, :timestamp
    end
  end
  
  def self.down
    drop_table :chat_users
    drop_table :chat_messages
  end  
end
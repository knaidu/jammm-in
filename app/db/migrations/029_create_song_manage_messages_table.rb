class CreateSongManageMessagesTable < ActiveRecord::Migration
  
  def self.up
    
    create_table :song_manage_messages do |i|
      i.column :song_id, :integer
      i.column :user_id, :integer
      i.column :message, :string
      i.column :created_at, :timestamp
    end    
    
  end
  
  def self.down
    drop_table :song_manage_messages
  end
end

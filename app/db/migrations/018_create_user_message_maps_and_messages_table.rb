class CreateUserMessageMapsAndMessagesTable < ActiveRecord::Migration
  
  def self.up
    # Song Like Table
    
    create_table :user_message_maps do |i|
      i.column :user_1_id, :integer
      i.column :user_2_id, :integer
    end
    
    create_table :messages do |i|
      i.column :user_message_map_id, :integer
      i.column :body, :string
      i.column :read, :boolean
      i.column :created_at, :timestamp, :default => Time.now
    end    
  end
  
  def self.down
    drop_table :messages
    drop_table :user_message_maps
  end
end

class CreateMessagesTable < ActiveRecord::Migration
  
  def self.up
    # Song Like Table
    create_table :messages do |i|
      i.column :from_id, :integer
      i.column :to_id, :integer
      i.column :subject, :string
      i.column :body, :string
      i.column :read, :boolean
      i.column :created_at, :timestamp, :default => Time.now
    end    
  end
  
  def self.down
    drop_table :messages
  end
end

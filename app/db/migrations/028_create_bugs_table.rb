class CreateBugsTable < ActiveRecord::Migration
  
  def self.up
    
    create_table :bugs do |i|
      i.column :subject, :string
      i.column :status, :string
      i.column :created_at, :timestamp
    end    
    
    create_table :bugs_body do |i|
      i.column :bug_id, :integer
      i.column :message, :string
      i.column :created_at, :timestamp
      i.column :user_id, :integer
    end
    
  end
  
  def self.down
    drop_table :bugs
    drop_table :bugs_body
  end
end

class CreateSaysTable < ActiveRecord::Migration
  def self.up
    create_table :says do |i|
      i.column :user_id, :integer
      i.column :message, :text
      i.column :created_at, :timestamp
    end    
  end
  
  def self.down
    drop_table :says
  end  
end